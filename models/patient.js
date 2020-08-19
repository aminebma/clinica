const mongoose = require('mongoose')
const Schema = mongoose.Schema

const patientSchema = new Schema({
    status:{
      type: String,
      enum: ['pending','approved','rejected']
    },
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
    sex:{
      type: String,
      required: true
    },
    address: {
        type: String,
        minlength:5,
        maxlength: 200,
        required: true
    },
    phoneNumber: {
        type: String,
        minlength: 9,
        maxlength: 14,
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
        maxlength: 4
    }
})

const Patient = mongoose.model('patient', patientSchema)

module.exports = Patient