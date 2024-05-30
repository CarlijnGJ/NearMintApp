const mysql = require('mysql2');
// require('dotenv').config({ path: '../.env' });
require('dotenv').config({ path: '.env' });
const crypto = require('crypto');


let currentDatabase;
switch (process.env.MODE_ENV) {
    case 'production':
        currentDatabase = process.env.DB_DATABASE;
        break;
    case 'development':
        currentDatabase = process.env.DB_TEST_DATABASE;
        break;
    default:
        currentDatabase = process.env.DB_DATABASE;
};

const hashedPassword = crypto.createHash('sha256').update(process.env.DB_PASSWORD, 'utf8').digest('hex');

// Database connection
const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: hashedPassword,
    database: currentDatabase,
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

module.exports = connection;