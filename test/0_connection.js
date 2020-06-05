const mongoose = require('mongoose')
const configIndex = require('../config/index')

before(function(done){

    //Connect to MongoDB
    mongoose.connect(configIndex.getDbConnectionString(), {useNewUrlParser: true, useUnifiedTopology: true})

    mongoose.connection.once('open', function(){
        console.log('Successfully connected...')
        done()
    }).on('error', function(error){
        console.log(`Connection error:\n ${error}`)
    })

})