const Boom = require('@hapi/boom')
const Doctor = require('../models/doctor')

const doctorsRoutes = [{
    method: 'GET',
    path: '/api/doctors/',
    handler: async (request, h) => {
        const doctors = await Doctor.find({},{password: 0})

        if(!doctors) throw Boom.notFound(`Aucun médecin disponible.`)

        return doctors
    }
}]

module.exports = doctorsRoutes