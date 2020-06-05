var configValues = require('./config')

module.exports = {

    getDbConnectionString: function(){
        return 'mongodb://' + configValues.uname + ':' + configValues.pwd + '@localhost:27017/db-clinica'
    }

}