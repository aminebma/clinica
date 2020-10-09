const express = require('express')
const router = express.Router()
const Joi = require('@hapi/joi')
const Boom = require('@hapi/boom')
const moment = require('moment')
const multer = require('multer')
const storageManager = multer.diskStorage({
    destination: function(req, file, callback){
        callback(null, './public/images')
    },
    filename: function(req, file, callback){
        callback(null,moment().format('DD-MM-YYYY') + '-' + Math.floor(Math.random() * (99999 - 11111) + 11111) + '-' +file.originalname + '.png')
    }
})

//Filtering uploaded files
const imageFilter = (req, file, callback)=>{
    if(file.mimetype==='image/jpeg' || file.mimetype === 'image/png')
        //Accept file
        callback(null,true)
    else
        //Reject file
        callback(new Error('Type de fichier non autorisé'),false)
}

const imageUpload = multer({
    storage: storageManager,
    limits:{
        fileSize: 1024*1024*10
    },
    fileFilter: imageFilter

})
const Request = require('../models/request')

const requestsRoutes = [
    {
        //Get a patient's requests
        method: 'GET',
        path: '/api/requests/patient/{id}',
        handler: async (request, h) => {
            const requests = await Request.find({patientId: request.params.id})

            if(!request) throw Boom.notFound(`No request found.`)

            return requests
        }
    },{
        //Get a doctor's pending requests
        method: 'GET',
        path: '/api/requests/{id}',
        handler: async (request, h) => {
            const requests = await Request.find({doctorId: request.params.id, status: 'pending'})

            if(!requests) throw Boom.notFound(`No request found.`)

            return requests
        }
    }, {
        //Get all requests of a doctor
        method: 'GET',
        path: '/api/requests/{id}/all',
        handler: async (request, h) => {
            const requests = await Request.find({doctorId: req.params.id})

            if(!requests) throw Boom.notFound(`No request found.`)

            return requests
        }
    },{
        //Get today's and yesterday's requests of a doctor
        method: 'GET',
        path: '/api/requests/{id}/two',
        handler: async (request, h) => {
            const today = moment.utc(moment()).format('yyyy-MM-DD')
            const yesterday = moment.utc(moment()).subtract(1, 'day').format('yyyy-MM-DD')
            const requests = await Request.find({
                doctorId: request.params.id,
                date: {
                    $gte: yesterday,
                    $lte: today
                }
            })

            if(!requests) throw Boom.notFound(`No request found.`)

            return requests
        }
    },{
        //Answering a request
        method: 'POST',
        path: '/api/requests/response',
        handler: async (request, h) => {
            const payload = request.payload
            const response = payload.answer.replace(/[#\\<>]/gi,'')
            const updatedRequest = await Request.findByIdAndUpdate(payload.id,{
                $set:{
                    response: response,
                    status: 'answered'
                }
            },{new: true, useFindAndModify: false})

            return updatedRequest._id
        }
    }
]

module.exports = requestsRoutes

//Add a new request to the database
router.post('/new', imageUpload.single('picture'),async (req, res)=>{
    // const {error} = validateRequest(req.body)
    // if(error) return res.status(400).send(error)

    let request = new Request({
        date: req.body.date,
        patientId: req.body.patientId,
        doctorId: req.body.doctorId,
        patientFirstName: req.body.patientFirstName,
        patientLastName: req.body.patientLastName,
        symptoms: req.body.symptoms,
        treatments: req.body.treatments,
        picture: req.file.filename,
        status: 'pending'
    })

    try {
        request = await request.save()
        res.send(request._id)
    } catch (err) {
        res.status(500).send(err.message)
    }
})

// //Validating the input data
// function validateRequest(request){
//     const schema = Joi.object({
//         date: Joi.string().required(),
//         patientId: Joi.string().required(),
//         doctorId: Joi.string().required(),
//         patientFirstName: Joi.string().min(3).max(35).required(),
//         patientLastName: Joi.string().min(3).max(20).required(),
//         symptoms: Joi.array().items(Joi.string().max(100)).required(),
//         treatments: Joi.string().max(25),
//         picture: Joi.string()
//     })
//
//     return schema.validate(request)
// }