const Joi = require('@hapi/joi')
const Boom = require('@hapi/boom')
const moment = require('moment')
const fs = require('fs')

const handleFileUpload = file => {
    return new Promise((resolve, reject) => {
        const filename = file.hapi.filename
        const data = file._data
        fs.writeFile('./public/images/' + moment().format('DD-MM-YYYY') + '-' + Math.floor(Math.random() * (99999 - 11111) + 11111) + '-' + filename, data, err => {
            if (err) {
                reject(err)
            }
            resolve({ message: 'Upload successfully!' })
        })
    })
}

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
        //Add a new request
        method: 'POST',
        path: '/api/requests/new',
        options:{
            payload: {
                output: 'stream',
                multipart: true
            }
        },
        handler: async(request, h) => {
            const { payload } = request
            const response = handleFileUpload(payload.file)
            let req = new Request({
                date: payload.date,
                patientId: payload.patientId,
                doctorId: payload.doctorId,
                patientFirstName: payload.patientFirstName,
                patientLastName: payload.patientLastName,
                symptoms: payload.symptoms,
                treatments: payload.treatments,
                picture: moment().format('DD-MM-YYYY') + '-' + Math.floor(Math.random() * (99999 - 11111) + 11111) + '-' + payload.file.hapi.filename,
                status: 'pending'
            })

            try {
                req = await req.save()
                console.log(`Request added successfully.`)
                return req._id
            } catch (err) {
                throw Boom.internal(err)
            }
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