const express = require('express')
const router = express.Router()
const Doctor = require('../models/doctor')

router.get('/', (req, res) => {
    Doctor.find((err, doctors)=>{
        if(err) throw err
        res.send(doctors)
    })
})

module.exports = router