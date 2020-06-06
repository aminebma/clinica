const express = require('express')
const router = express.Router()
const config = require('config')
const Joi = require('joi')
const _ = require('lodash')
const bCrypt = require('bcrypt')
const Patient = require('../models/patient')

router.post('/sign_in', async (req, res) => {

    const{error} = validateAccount(req.body)
    if(error) return res.status(400).send(error)
    let patient = await Patient.findOne({phoneNumber: req.body.phoneNumber})
    if(patient) return res.status(400).send("Utilisateur déjà inscrit.")

    patient = new Patient(_.pick(req.body, ['firstName','lastName','address','phoneNumber','mail']))

    const pass = (Math.floor(Math.random() * (9999 - 1111 +1) + 1111)).toString()
    const client = require('twilio')(config.get("sms.accountSid"), config.get("sms.authToken"))
    client.messages
        .create({
            body: pass,
            from: '+12056516382',
            to: patient.phoneNumber
        })
        .then(message => console.log(`Message send to ${message.to}. Content: ${message.body}`))
        .catch(err => console.log(err.message));

    const salt = await bCrypt.genSalt(10)
    patient._doc.password = await bCrypt.hash(pass,salt)

    try{
        await patient.save()
        res.send(patient)
    }catch(err){
        res.status(500).send("Erreur lors de l'ajout dans la base de données")
    }
})

function validateAccount(patient){
    const schema = {
        firstName: Joi.string().min(3).max(35).required(),
        lastName: Joi.string().min(3).max(20).required(),
        address: Joi.string().min(5).max(200).required(),
        phoneNumber: Joi.string().min(9).max(14).required(),
        mail: Joi.string().min(5).max(100).required().email()
    }

    return Joi.validate(patient, schema)
}

module.exports = router