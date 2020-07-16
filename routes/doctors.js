const express = require('express')
const router = express.Router()
const Doctor = require('../models/doctor')

//Get all doctors
router.get('/', async (req, res) => {
    await Doctor.find({},{password: 0},(err, doctors)=>{
        if(err) throw err
        res.send(doctors)
    })
})

module.exports = router