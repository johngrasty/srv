var path = require('path'),
    config;

config = {
    production: {
        url: 'http://needfaith.org',
        mail: {
          transport: 'sendmail',
          fromaddress: 'ghost@needfaith.org',
          options: {}
        },
        database: {
          client: 'mysql',
          connection: {
            host     : '10.0.0.4',
            user     : 'john_ghost',
            password : 'uMd84g4diyUMkeB2LeMMkniW',
            database : 'needfaith_ghost',
            charset  : 'utf8'
          }
        },
        server: {
            host: '10.0.0.2',
            port: '2368'
        },
        paths: {
            contentPath: path.join(__dirname, '/content/')
        }
    }
};
module.exports = config;
