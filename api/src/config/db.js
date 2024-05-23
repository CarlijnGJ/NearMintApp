const mysql = require('mysql2');
require('dotenv').config({ path: '../.env' });

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

// Database connection
const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
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
