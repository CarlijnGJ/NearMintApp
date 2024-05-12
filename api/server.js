const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const cors = require('cors');
const basicAuth = require('express-basic-auth');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Basic authentication middleware
const users = {};
users[process.env.BASIC_AUTH_USERNAME] = process.env.BASIC_AUTH_PASSWORD;
const authenticate = basicAuth({
    users,
    challenge: true,
    realm: 'Swagger API Documentation'
});

// Swagger API documentation setup
const options = {
    definition: {
        openapi: '3.0.0',
        info: {
            title: 'NearMintGaming API Documentation',
            version: '1.0.0',
            description: 'API endpoints for NearMintGaming',
        },
    },
    apis: [__filename], // This file itself contains the API documentation
};
const swaggerSpec = swaggerJsdoc(options);
app.use('/api-docs', authenticate, swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Database connection
const connection = mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE
});
connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// Routes
/**
 * @swagger
 * /api/members:
 *   get:
 *     summary: Retrieve all members
 *     description: Retrieve a list of all members from the database.
 *     responses:
 *       '200':
 *         description: A JSON array of member objects.
 *       '500':
 *         description: Internal server error.
 */
app.get('/api/members', (req, res) => {
    const query = 'SELECT * FROM Members';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }
        res.json(results);
    });
});

/**
 * @swagger
 * /api/members:
 *   post:
 *     summary: Create a new member
 *     description: Add a new member to the database.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nickname:
 *                 type: string
 *                 description: The nickname of the member.
 *               name:
 *                 type: string
 *                 description: The full name of the member.
 *               password:
 *                 type: string
 *                 format: password
 *                 description: The password of the member.
 *               avatar:
 *                 type: string
 *                 format: url
 *                 description: The URL of the member's avatar image.
 *     responses:
 *       '201':
 *         description: Member created successfully.
 *       '400':
 *         description: Bad request. Missing or invalid request body.
 *       '500':
 *         description: Internal server error.
 */
app.post('/api/members', async (req, res) => {
    const { nickname, name, password, avatar } = req.body;

    // Check if all required fields are provided
    if (!nickname || !name || !password || !avatar) {
        res.status(400).json({ error: 'Nickname, name, password, and avatar are required' });
        return;
    }

    try {
        // Generate salt
        const salt = await bcrypt.genSalt(10);
        // Hash the password with the salt
        const hashedPassword = await bcrypt.hash(password, salt);

        const query = 'INSERT INTO Members (nickname, name, password, avatar) VALUES (?, ?, ?, ?)';
        connection.query(query, [nickname, name, hashedPassword, avatar], (err, results) => {
            if (err) {
                console.error('Error executing MySQL query:', err);
                res.status(500).json({ error: 'Internal server error' });
                return;
            }
            res.status(201).json({ message: 'Member created successfully' });
        });
    } catch (error) {
        console.error('Error hashing password:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: login
 *     description: Login to the application.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nickname:
 *                 type: string
 *                 description: The nickname of the member.
 *               password:
 *                 type: string
 *                 format: password
 *                 description: The password of the member.
 *     responses:
 *       '201':
 *         description: Logged in successfully.
 *       '400':
 *         description: Bad request. Nickname and password are required.
 *       '404':
 *         description: Bad request. Member not found.
 *       '401':
 *         description: Bad request. Incorrect password.
 *       '500':
 *         description: Internal server error.
 */
app.post('/api/login', async (req, res) => {
    const { nickname, password } = req.body;

    // Check if all required fields are provided
    if (!nickname || !password) {
        res.status(400).json({ error: 'Nickname and password are required' });
        return;
    }
    try {
        const query = 'SELECT * FROM Members WHERE nickname = ?';
        connection.query(query, [nickname, password], (err, results) => {
            if (results.length === 0) {
                res.status(404).json({ error: 'Member not found' });
                return;
            } else if (password !== results[0].password) {
                res.status(401).json({ error: 'Incorrect password' });
                return;            
            }
            if (err) {
                console.error('Error executing MySQL query:', err);
                res.status(500).json({ error: 'Internal server error' });
                return;
            }
            res.status(201).json({ message: 'Logged in successfully' });
        });
    } catch (error) {
        console.error('Error hashing password:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
// Start the server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
