const express = require('express')
const router = express.Router()
const Joi = require('@hapi/joi')
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
    if(file.mimetype==='image/jpeg' || file.mimetype === 'image/png' || file.mimetype ==='image/*')
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


router.get('/patient/:id', async (req, res)=>{
    const requests = await Request.find({patientId: req.params.id})
    res.send(requests)
})

//Get a doctor's pending requests
router.get('/:id',async (req, res)=>{
    const requests = await Request.find({doctorId: req.params.id, status: 'pending'})
    res.send(requests)
})

//Get today's and yesterday's requests of a doctor
router.get('/:id/all', async (req,res)=> {
    const today = moment.utc(moment())
    const yesterday = moment.utc(moment()).subtract(1, 'day')
    await Request.find({
        doctorId: req.params.id,
        date: {
            $gte: yesterday,
            $lte: today
        }
    }, async (err, requests) => {
        if (err) throw err
        res.send(requests)
    })
})

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

//Answering a request
router.post('/response',async (req, res)=>{
    const response = req.body.answer.replace(/[#\\<>]/gi,'')
    const updatedRequest =await Request.findByIdAndUpdate(req.body.id,{
        $set:{
            response: response,
            status: 'answered'
        }
    },{new: true, useFindAndModify: false})
    res.send(updatedRequest._id)
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

module.exports = router