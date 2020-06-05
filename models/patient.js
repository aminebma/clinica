const mongoose = require('mongoose')
const Schema = mongoose.Schema()

const patientSchema = new Schema({
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
    address: {
        type: String,
        required: true
    },
    phoneNumber: {
        type: String,
        required: true
    },
    mail: {
        type: String,
        minlength: 5,
        maxlength:100,
        required: true
    },
    password: {
        type: String,
        minlength: 4,
        maxlength: 4,
        required: true
    }
})

const Patient = mongoose.model('patient', patientSchema)

module.exports = Patient