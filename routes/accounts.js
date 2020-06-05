const express = require('express')
const router = express.Router()
const config = require('config')
const _ = require('lodash')
const bcrypt = require('bcrypt')
const Patient = require('../models/patient')

router.post('/add_user', async (req, res) => {

    const patient = _.pick(req.body, ['firstName','lastName','address','phoneNumber','mail'])

    const {error} = validateAccount(patient)
    if(error){
        let errors = ""
        for(e in error.details) errors += e.message
        res.status(400).send(errors)
        return
    }

    pass = Math.floor(Math.random() * (9999 - 1111 +1) + 1111)
    const client = require('twilio')(config.get("sms.accountSid"), config.get("sms.authToken"))
    client.messages
        .create({
            body: pass.toString(),
            from: '+12056516382',
            to: patient.phoneNumber
        })
        .then(message => console.log(message.sid));

    const salt = await bcrypt.genSalt(10)
    const hPass = await bcrypt.hash(pass,salt)

    patient.password = hPass
    patient.save((err)=>{
        if(err) throw err
    })
})

function validateAccount(patient){
    const schema = {
        firstName: Joi.string().min(3).max(35).required(),
        lastName: Joi.string().min(3).max(20).required(),
        address: Joi.string().min(5).max(200).required(),
        phoneNumber: Joi.string().min(9).max(14).required(),
        mail: Joi.string().min(5).max(100).required()
    }

    return Joi.validate(patient, schema)
}

module.exports = router