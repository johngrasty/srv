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
            client: 'sqlite3',
            connection: {
                filename: path.join(__dirname, '/content/data/ghost.db')
            },
            debug: false
        },
        server: {
            host: '127.0.0.1',
            port: '2368'
        },
        paths: {
            contentPath: path.join(__dirname, '/content/')
        }
    }
};
module.exports = config;
