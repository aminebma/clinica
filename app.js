const Hapi = require('@hapi/hapi')
const Inert = require('inert')
const mongoose = require('mongoose')
const configIndex = require('./config/index')
const config = require('config')


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
        host: serverIp,
    })

    await server.register(Inert)

    //Accounts routes
    server.route(require('./routes/accounts'))

    //Requests routes
    server.route(require('./routes/requests'))

    //Doctors routes
    server.route(require('./routes/doctors'))

    server.route({
        method: 'GET',
        path: '/images/{filename*}',
        handler: {
            directory: {
                path: 'public/images'
            }
        }
    })

    try{
        await server.start()
        console.log(`Listening on port ${serverPort}`)
    }catch(e){
        console.log(`An error occured: ${e}`)
    }

}

//Starting the server
init()