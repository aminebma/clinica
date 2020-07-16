const mongoose = require('mongoose')
const Schema = mongoose.Schema

const requestSchema = new Schema({
    date: {
        type: Date,
        required: true
    },
    patientId: {
        type: mongoose.Types.ObjectId,
        required: true
    },
    doctorId: {
        type: mongoose.Types.ObjectId,
        required: true
    },
    patientFirstName: {
        type: String,
        minlength: 3,
        maxlength: 35,
        required: true
    },
    patientLastName: {
        type: String,
        minlength: 3,
        maxlength: 20,
        required: true
    },
    symptoms:{
        type: [String],
        maxlength: 100,
        required: true
    },
    treatments:{
        type: String,
        maxlength: 25
    },
    picture:{
        type: String
    },
    response:{
        type: String
    },
    status:{
        type: String,
        enum: ['pending','answered']
    }
})

const Request = mongoose.model('request', requestSchema)

module.exports = Request