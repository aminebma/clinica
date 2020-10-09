// const express = require('express')
const Hapi = require('@hapi/hapi')
// const helmet = require('helmet')
// const compression = require('compression')
// const morgan = require('morgan')
const mongoose = require('mongoose')
const configIndex = require('./config/index')
const config = require('config')
// const accounts = require('./routes/accounts')
// const doctors = require('./routes/doctors')
// const requests = require('./routes/requests')
// const app = express()

// //Middlewares
// app.use(express.json())
// app.use(express.urlencoded({extended: true}))
// app.use(express.static('public'))
// app.use(helmet())
// app.use(compression())
// if(app.get('env') === 'development')
//     app.use(morgan('tiny'))
//
// //Routes
// app.use('/api/accounts', accounts)
// app.use('/api/doctors', doctors)
// app.use('/api/requests', requests)

//Connecting to the database
mongoose.connect(configIndex.getDbConnectionString(), {useNewUrlParser: true, useUnifiedTopology: true})
mongoose.connection.once('open',function(){
    console.log('Successfully connected to the database...')
}).on('error', function(error){
    console.log(`Failed connecting to the database.\n${error}`)
})

//Environment Port and Ip
const serverPort = config.get("server.port")
const serverIp = config.get("server.ip")

const init = async () => {

    const server = Hapi.server({
        port: serverPort,
        host: serverIp
    })

    //Accounts routes
    server.route(require('./routes/accounts'))

    //Requests routes
    server.route(require('./routes/requests'))

    //Doctors routes
    server.route(require('./routes/doctors'))


    try{
        await server.start()
        console.log(`Listening on port ${serverPort}`)
    }catch(e){
        console.log(`An error occured: ${e}`)
    }

}

//Starting the server
init()
// app.listen(process.env.PORT, () => console.log(`Listening on port ${port}`))