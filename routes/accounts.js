const config = require('config')
const Joi = require('@hapi/joi')
const Boom = require('@hapi/boom')
const _ = require('lodash')
const bCrypt = require('bcrypt')
const Patient = require('../models/patient')
const Doctor = require('../models/doctor')
const client = require('twilio')(config.get("sms.accountSid"), config.get("sms.authToken"))
const jwt = require('jsonwebtoken')

const accountsRoutes = [
    {
        //Creating a patient account in the database
        method: 'POST',
        path: '/api/accounts/sign-up',
        handler: async (request, h) => {
            const payload = request.payload
            const {error} = validateAccount(payload)
            if (error) {
                console.error(error)
                throw Boom.badData(error)
            }

            let patient = await Patient.findOne({phoneNumber: payload.phoneNumber})
            if (patient) {
                if (patient._doc.status === 'approved') {
                    console.error(`Utilisateur déjà inscrit`)
                    return h.response(`Utilisateur déjà inscrit`).code(208)
                } else {
                    await client.verify.services.create({friendlyName: 'Clinica', codeLength: 4})
                        .then(async service => {
                            console.log(service.sid)
                            sid = service.sid
                            await client.verify.services(service.sid)
                                .verifications
                                .create({to: payload.phoneNumber, channel: 'sms'})
                                .then(async verification => {
                                    console.log(verification.status)
                                    try {
                                        return service.sid
                                    } catch (err) {
                                        throw Boom.internal(err)
                                    }
                                }).catch(err => throw Boom.internal(err))
                        }).catch(err => throw Boom.internal(err))
                }
            } else {
                patient = new Patient(_.pick(payload, ['firstName', 'lastName', 'sex', 'address', 'phoneNumber', 'mail']))

                await client.verify.services.create({friendlyName: 'Clinica', codeLength: 4})
                    .then(async service => {
                        console.log(service.sid)
                        sid = service.sid
                        await client.verify.services(service.sid)
                            .verifications
                            .create({to: payload.phoneNumber, channel: 'sms'})
                            .then(async verification => {
                                console.log(verification.status)
                                try {
                                    patient._doc.status = verification.status
                                    await patient.save()
                                    return service.sid
                                } catch (err) {
                                    throw Boom.internal(err)
                                }
                            }).catch(err => throw Boom.internal(err))
                    }).catch(err => throw Boom.internal(err))
            }
        }
    }, {
        //Verifying the patient's account
        method: 'POST',
        path: '/api/accounts/sign-up/verify',
        handler: async (request, h) => {
            const payload = request.payload
            const {error} = validateToken(payload)
            if (error) {
                console.error(error)
                throw Boom.badData(error)
            }

            await client.verify.services(payload.sid)
                .verificationChecks
                .create({to: payload.phoneNumber, code: payload.code})
                .then(async verification_check => {
                    console.log(verification_check.status)
                    if(verification_check.status==='approved'){
                        const salt = await bCrypt.genSalt(10)
                        const pass = await bCrypt.hash(payload.code.toString(),salt)

                        try{
                            const patient = await Patient.findOneAndUpdate({phoneNumber: payload.phoneNumber, status: 'pending'},{
                                $set:{
                                    status: 'approved',
                                    password: pass
                                }
                            },{new: true, useFindAndModify: false})
                            return patient._id
                        } catch(err){
                            throw Boom.internal(err)
                        }
                    }
                    else throw Boom.badRequest(`Invalid code.`)
                }).catch(
                    err => {
                        console.error(err)
                        throw Boom.internal(err)
                    }
                )
        }
    }, {
        //Connect a user
        method: 'POST',
        path: '/api/accounts/sign-in',
        handler: async (request, h) => {
            const payload = request.payload
            const { error } = validateLogin(payload)
            if (error) {
                console.error(error)
                throw Boom.badData(error)
            }

            await Patient.findOne({phoneNumber: payload.phoneNumber})
                .then( async patient =>{
                    if(!patient){
                        await Doctor.findOne({phoneNumber: payload.phoneNumber})
                            .then(async doctor => {
                                if(!doctor) throw Boom.badRequest(`Incorrect phone number or password`)

                                const validPass = (payload.password===doctor._doc.password) ? true : false
                                if(!validPass) throw Boom.badRequest(`Incorrect phone number or password`)

                                delete doctor._doc.password
                                const token = jwt.sign({_id: doctor._doc._id}, config.get('auth.jwtPK'))
                                doctor._doc.jwt = token
                                doctor._doc.type = 1
                                return doctor
                            })
                            .catch(e => {
                                console.error(e)
                                throw Boom.internal(e)
                            })
                    }
                    else {
                        const validPass = await bCrypt.compare(payload.password, patient._doc.password)
                        if (!validPass) throw Boom.badRequest(`Incorrect phone number or password`)

                        delete patient._doc.password
                        const token = jwt.sign({_id: patient._doc._id}, config.get('auth.jwtPK'))
                        patient._doc.jwt = token
                        patient._doc.type = 0
                        return patient
                    }
                })
                .catch(e => {
                    console.error(e)
                    throw Boom.internal(e)
                })
        }
    }
]

//Validating the input data
function validateAccount(patient){
    const schema = Joi.object({
        firstName: Joi.string().min(3).max(35).required(),
        lastName: Joi.string().min(3).max(20).required(),
        sex: Joi.string().required(),
        address: Joi.string().min(5).max(200).required(),
        phoneNumber: Joi.string().min(9).max(14).required(),
        mail: Joi.string().min(5).max(100).required().email()
    })

    return schema.validate(patient)
}

function validateToken(code){
    const schema= Joi.object({
        code: Joi.number().max(9999).required(),
        sid: Joi.string(),
        phoneNumber: Joi.string()
    })

    return schema.validate(code)
}

function validateLogin(account){
    const schema = Joi.object({
        phoneNumber: Joi.string().min(9).max(14).required(),
        password: Joi.string().min(4).max(4).required()
    })
    return schema.validate(account)
}