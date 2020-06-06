const express = require('express')
const router = express.Router()
const Joi = require('joi')
const Request = require('../models/request')

router.post('/add_request', (req, res)=>{
    const request = new Request({
        patientId: req.body.patientId,
        doctorId: req.body.doctorId,
        body: req.body.body
    })

    const {error} = validateRequest(request)
    if(error){
        res.status(400).send(error.details[0].message)
        return
    }

    request.save((err)=>{
        if(err) throw err
        res.send(request)
    })
})

// function validateRequest(request){
//     const schema = {
//         patientId: Joi.string().required(),
//         doctorId: Joi.string().required()
//     }
//
//     return Joi.validate(request, schema)
// }

module.exports = router