const mongoose = require('mongoose')
const Schema = mongoose.Schema

const doctorSchema = new Schema({
    firstName: {
        type: String,
        minlength: 3,
        maxlength: 35,
        required: true
    },
    lastName: {
        type: String,
        minlength: 3,
        maxlength: 20,
        required: true
    },
    picture: {
        type: String,
        required: true
    },
    speciality: {
        type: String,
        minlength: 5,
        maxlength: 20,
        required: true
    },
    phoneNumber: {
        type: String,
        minlength: 9,
        maxlength: 14,
        required: true
    },
    password: {
        type: String,
        minlength: 4,
        maxlength: 4
    }
})

const Doctor = mongoose.model('doctor', doctorSchema)

module.exports = Doctor