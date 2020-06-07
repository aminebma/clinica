const express = require('express')
const router = express.Router()
const config = require('config')
const Joi = require('@hapi/joi')
const _ = require('lodash')
const bCrypt = require('bcrypt')
const Patient = require('../models/patient')
const client = require('twilio')(config.get("sms.accountSid"), config.get("sms.authToken"))

//Creating a Patient account in the database
router.post('/sign_in', async (req, res) => {

    const {error} = validateAccount(req.body)
    if(error) return res.status(400).send(error)

    let patient = await Patient.findOne({phoneNumber: req.body.phoneNumber})
    if(patient) return res.status(400).send("Utilisateur déjà inscrit.")

    patient = new Patient(_.pick(req.body, ['firstName','lastName','address','phoneNumber','mail']))

    await client.verify.services.create({friendlyName: 'Clinica', codeLength: 4})
        .then(async service => {
            console.log(service.sid)
            sid = service.sid
            await client.verify.services(service.sid)
                .verifications
                .create({to: req.body.phoneNumber, channel: 'sms'})
                .then(async verification => {
                    console.log(verification.status)
                    try{
                        patient._doc.status = verification.status
                        await patient.save()
                        res.send(service.sid)
                    }catch(err){
                        res.status(500).send(err)
                    }
                }).catch(err => res.send(err))
        }).catch(err => res.send(err))
})

router.post('/sign_in/verify',async (req,res)=>{

    const {error} = validateToken(req.body)
    if(error) return res.status(400).send(error)

    await client.verify.services(req.body.sid)
        .verificationChecks
        .create({to: req.body.phoneNumber, code: req.body.code})
        .then(async verification_check => {
            console.log(verification_check.status)
            if(verification_check.status==='approved'){
                const salt = await bCrypt.genSalt(10)
                const pass = await bCrypt.hash(req.body.code,salt)

                try{
                    const patient = await Patient.findOneAndUpdate({phoneNumber: req.body.phoneNumber, status: 'pending'},{
                        $set:{
                            status: 'approved',
                            password: pass
                        }
                    },{new: true, useFindAndModify: false})
                    res.send(patient._id)
                }catch(err){
                    res.status(500).send(err.message)
                }
            }
            else {
                res.status(400).send(new Error('Le code entré est incorrect.'))
            }
        }).catch(err => res.send(err))
})

//Validating the input data
function validateAccount(patient){
    const schema = Joi.object({
        firstName: Joi.string().min(3).max(35).required(),
        lastName: Joi.string().min(3).max(20).required(),
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

module.exports = router