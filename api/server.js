const express = require('express');
const mysql = require('mysql2');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const cors = require('cors');
const crypto = require('crypto');
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
// Routes
/**
 * @swagger
 * /api/member:
 *  get:
 *    summary: Get a member by session key
 *    description: Retrieve user information by session key
 *    parameters:
 *      - in: query
 *        name: session_key
 *        schema:
 *          type: string
 *        required: true
 *        description: Session key of the user to retrieve
 *    responses:
 *      200:
 *        description: Successful operation
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              properties:
 *                nickname:
 *                  type: string
 *                  description: The user's nickname
 *                name:
 *                  type: string
 *                  description: The user's name
 *                avatar:
 *                  type: string
 *                  description: URL of the user's avatar image
 *      404:
 *        description: User not found
 */
app.get('/api/member', (req, res) => {
    const sessionKey = req.query.session_key;

    // Query to retrieve member_id associated with the provided session key
    const sessionQuery = 'SELECT member_id FROM Session WHERE session_key = ?';
    connection.query(sessionQuery, [sessionKey], (err, sessionResults) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            res.status(500).json({ error: 'Internal server error' });
            return;
        }

        if (sessionResults.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const memberId = sessionResults[0].member_id;

        // Query to retrieve member data using the retrieved member_id
        const memberQuery = 'SELECT nickname, name, avatar FROM Members WHERE member_id = ?';
        connection.query(memberQuery, [memberId], (err, memberResults) => {
            if (err) {
                console.error('Error executing MySQL query:', err);
                res.status(500).json({ error: 'Internal server error' });
                return;
            }
            
            if (memberResults.length === 0) {
                res.status(404).json({ error: 'User not found' });
                return;
            }

            // Send member data in response
            res.status(200).json({ 
                nickname: memberResults[0].nickname, 
                name: memberResults[0].name, 
                avatar: memberResults[0].avatar 
            });
        });
    });
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
        if (process.env.NODE_ENV === 'development') {
            res.status(400).json({ error: 'Nickname and password are required' });
        }
        return;
    }
    try {
        const query = 'SELECT * FROM Members WHERE nickname = ?';
        connection.query(query, [nickname, password], (err, results) => {
            if (results.length === 0) {
                if (process.env.NODE_ENV === 'development') {
                    res.status(404).json({ error: 'Incorrect nickname or password' });
                } 
                return;
            } else if (password !== results[0].password) {
                if (process.env.NODE_ENV === 'development') {
                    res.status(404).json({ error: 'Incorrect nickname or password' });
                }
                return;            
            }
            if (err) {
                if (process.env.NODE_ENV === 'development') {
                    console.error('Error executing MySQL query:', err);
                    res.status(500).json({ error: 'Internal server error' }); 
                }
                return;
            }
              // If authentication is successful, generate a session key
            const sessionKey = crypto.randomBytes(16).toString('hex');
            // Getting the member_id from the login
            var memberId = results[0].member_id;
            connection.query('INSERT INTO Session (session_key, member_id) VALUES (?, ?)', [sessionKey, memberId], (err) => {
                if (err) {
                    console.error('Error inserting session:', err);
                    res.status(501).json({ error: 'Internal server error' });
                    return;
                }
                // Send the encrypted session key to the front end
                res.status(201).json({ session_key: sessionKey });
            });
        });
    } catch (error) {
        if (process.env.NODE_ENV === 'development') {
            console.error('Error hashing password:', error);
            res.status(500).json({ error: 'Internal server error' });
        }
    }
});


// Start the server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
