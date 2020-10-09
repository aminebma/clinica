const express = require('express')
const helmet = require('helmet')
const compression = require('compression')
const morgan = require('morgan')
const mongoose = require('mongoose')
const configIndex = require('./config/index')
const config = require('config')
const accounts = require('./routes/accounts')
const doctors = require('./routes/doctors')
const requests = require('./routes/requests')
const app = express()

//Middlewares
app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(express.static('public'))
app.use(helmet())
app.use(compression())
if(app.get('env') === 'development')
    app.use(morgan('tiny'))

//Routes
app.use('/api/accounts', accounts)
app.use('/api/doctors', doctors)
app.use('/api/requests', requests)

//Connecting to the database
mongoose.connect(configIndex.getDbConnectionString(), {useNewUrlParser: true, useUnifiedTopology: true})
mongoose.connection.once('open',function(){
    console.log('Successfully connected to the database...')
}).on('error', function(error){
    console.log(`Failed connecting to the database.\n${error}`)
})

//Environment Port and Ip
const port = config.get("server.port")
// const ip = "192.168.43.191"
// // config.get("server.ip")

//Starting the server
app.listen(process.env.PORT, () => console.log(`Listening on port ${port}`))