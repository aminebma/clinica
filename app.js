const express = require('express')
const helmet = require('helmet')
const morgan = require('morgan')
const mongoose = require('mongoose')
const configIndex = require('./config/index')
const accounts = require('./routes/accounts')
const patients = require('./routes/patients')
const doctors = require('./routes/doctors')
const app = express()

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(express.static('public'))
app.use(helmet())

if(app.get('env') === 'development')
    app.use(morgan('tiny'))

app.use('/api/accounts', accounts)
app.use('/api/patients', patients)
app.use('/api/doctors', doctors)

mongoose.connect(configIndex.getDbConnectionString(), {useNewUrlParser: true, useUnifiedTopology: true})
mongoose.connection.once('open',function(){
    console.log('Successfully connected to the database')
}).on('error', function(error){
    console.log('Failed connecting to the database.\n',error)
})

//Port
const port = process.env.PORT || 3000
app.listen(port, '127.0.0.1', () => console.log(`Listening on port ${port}`))
