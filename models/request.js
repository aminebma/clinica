const mongoose = require('mongoose')
const Schema = mongoose.Schema

const requestSchema = new Schema({
    patientId: {
        type: mongoose.Types.ObjectId,
        required: true
    },
    doctorId: {
        type: mongoose.Types.ObjectId,
        required: true
    },
    symptoms:{
        type: [String],
        minlength: 3,
        maxlength: 100,
        required: true
    },
    treatments:{
        type: String,
        minlength: 5,
        maxlength: 25
    },
    picture:{
        type: String
    }
})

const Request = mongoose.model('request', requestSchema)

module.exports = Request