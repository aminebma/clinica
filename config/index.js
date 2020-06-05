const config = require('config')

module.exports = {
    getDbConnectionString: function(){
        console.log('Application name: '+config.get("name"))
        console.log('Database name: '+config.get("database.name"))
        return `mongodb://${config.get("database.username")}:${config.get("database.password")}@${config.get("database.ip")}:${config.get("database.port")}/${config.get("database.name")}`
    }
}