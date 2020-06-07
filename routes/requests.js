const express = require('express')
const router = express.Router()
const Joi = require('@hapi/joi')
const Request = require('../models/request')

//Get a doctor's requests
router.get('/:id',async (req, res)=>{
    const requests = await Request.find({doctorId: req.params.id, status: 'pending'})
    res.send(requests)
})

//Add a new request to the database
router.post('/add_request', async (req, res)=>{
    const {error} = validateRequest(req.body)
    if(error) return res.status(400).send(error)

    let request = new Request({
        patientId: req.body.patientId,
        doctorId: req.body.doctorId,
        symptoms: req.body.symptoms,
        treatments: req.body.treatments,
        picture: req.body.picture,
        status: 'pending'
    })

    try {
        request = await request.save()
        res.send(request._id)
    } catch (err) {
        res.status(500).send(err.message)
    }
})

//Answering a request
router.post('/response',async (req, res)=>{
    const response = req.body.response.replace(/[#\\<>]/gi,'')
    const updatedRequest = await Request.findOneAndUpdate({_id: req.body.id},{
        $set:{
            response: response,
            status: 'answered'
        }
    },{new: true, useFindAndModify: false})
    res.send(updatedRequest._id)
})

//Validating the input data
function validateRequest(request){
    const schema = Joi.object({
        patientId: Joi.string().required(),
        doctorId: Joi.string().required(),
        symptoms: Joi.array().items(Joi.string().min(3).max(100)).required(),
        treatments: Joi.string().min(5).max(25),
        picture: Joi.string()
    })

    return schema.validate(request)
}

module.exports = router