const express = require('express')
const router = express.Router()
const Joi = require('@hapi/joi')
const Request = require('../models/request')

//Get a doctor's requests
router.get('/:id',async (req, res)=>{
    const requests = await Request.find({doctorId: req.params.id})
    res.send(requests)
})

//Add a new request to the database
router.post('/add_request', async (req, res)=>{
    const {error} = validateRequest(req.body)
    if(error) return res.status(400).send(error)

    const request = new Request({
        patientId: req.body.patientId,
        doctorId: req.body.doctorId,
        body: req.body.body
    })

    try {
        await request.save()
        res.send(request)
    } catch (err) {
        res.status(500).send(err.message)
    }
})

//Validating the input data
function validateRequest(request){
    const schema = Joi.object({
        patientId: Joi.string().required(),
        doctorId: Joi.string().required(),
        symptoms: [Joi.string().min(3).max(100).required()],
        treatments: Joi.string().min(5).max(25),
        picture: Joi.string()
    })

    return schema.validate(request)
}

module.exports = router