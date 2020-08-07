const config = require('config')

module.exports = {
    getDbConnectionString: function(){
        console.log('Application name: '+config.get("name"))
        console.log('Database name: '+config.get("database.name"))
        return `mongodb+srv://${config.get("database.username")}:${config.get("database.password")}@clinica.nqbdc.mongodb.net/${config.get("database.name")}?retryWrites=true&w=majority`
    }
}