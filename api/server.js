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

// Basic authentication middleware for Swagger UI
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
            version: '0.5.0',
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


/**
 * Middleware to validate session key
 */
function validateSessionKey(req, res, next) {
    // Extract the session key from the "Authorization" header

    const sessionKey = req.headers.auth;
    // Check if the session key is present
    if (!sessionKey) {
        return res.status(401).json({ error: 'Unauthorized: No session key provided' });
    }

    // Query the database to validate the session key
    const query = 'SELECT member_id FROM Session WHERE session_key = ?';
    connection.query(query, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        // Check if the session key is valid
        if (results.length === 0) {
            return res.status(401).json({ error: 'Unauthorized: Invalid session key' });
        }

        // If the session key is valid, attach the member ID to the request object
        req.memberId = results[0].member_id;
        next();
    });
}

function deleteSessionKey(req, res, next) {
    const sessionKey = req.headers.auth;

    if (!sessionKey) {
        return res.status(400).json({ error: 'Session key not provided in header' });
    }

    const deleteQuery = 'DELETE FROM Session WHERE session_key = ?';
    connection.query(deleteQuery, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }   

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Session key not found' });
        }

        // Session key successfully deleted
        next();
    });
}

/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: Login to the application
 *     description: Authenticates a user and returns a session key
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nickname:
 *                 type: string
 *                 description: The nickname of the member
 *               password:
 *                 type: string
 *                 format: password
 *                 description: The password of the member
 *     responses:
 *       201:
 *         description: Logged in successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 session_key:
 *                   type: string
 *                   description: The session key for the logged-in user
 *       400:
 *         description: Bad request. Nickname and password are required
 *       401:
 *         description: Unauthorized. Incorrect nickname or password
 *       500:
 *         description: Internal server error
 */
app.post('/api/login', (req, res) => {
    const { nickname, password } = req.body;

    if (!nickname || !password) {
        return res.status(400).json({ error: 'Nickname and password are required' });
    }

    const query = 'SELECT * FROM Members WHERE nickname = ?';
    connection.query(query, [nickname], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0 || results[0].password !== password) {
            return res.status(401).json({ error: 'Incorrect nickname or password' });
        }

        const memberId = results[0].member_id;
        const sessionKey = crypto.randomBytes(16).toString('hex');

        const sessionQuery = 'INSERT INTO Session (session_key, member_id) VALUES (?, ?)';
        connection.query(sessionQuery, [sessionKey, memberId], (err) => {
            if (err) {
                console.error('Error inserting session:', err);
                return res.status(500).json({ error: 'Internal server error' });
            }
            res.status(201).json({ session_key: sessionKey });
        });

    });
});

/**
 * @swagger
 * /api/member:
 *  get:
 *    summary: Get a member by session key
 *    description: Retrieve user information by session key
 *    parameters:
 *      - name: auth
 *        in: header
 *        required: true
 *        schema:
 *          type: string
 *          description: Session key of the user
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
app.get('/api/member', validateSessionKey, (req, res) => {
    const memberId = req.memberId;

    const memberQuery = 'SELECT nickname, name, avatar FROM Members WHERE member_id = ?';
    connection.query(memberQuery, [memberId], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({
            nickname: results[0].nickname,
            name: results[0].name,
            avatar: results[0].avatar
        });
    });
});

/**
 * @swagger
 * /api/logout:
 *  delete:
 *    summary: Logout of the application
 *    description: Remove the session key
 *    parameters:
 *      - name: auth
 *        in: header
 *        required: true
 *        schema:
 *          type: string
 *          description: Session key of the user
 *    responses:
 *      200:
 *        description: Successfully deleted session
 */
app.delete('/api/logout', deleteSessionKey, (req, res) => {
    res.status(200).json({ message: 'Logout successful' });
});

/**
 * @swagger
 * /api/members:
 *   get:
 *     summary: Retrieve all members
 *     description: Retrieve a list of all members from the database
 *     parameters:
 *      - in: header
 *        name: auth
 *        schema:
 *          type: string
 *        required: true
 *        description: Session key of the user to retrieve
 *     responses:
 *       200:
 *         description: A JSON array of member objects
 *       500:
 *         description: Internal server error
 */
app.get('/api/members', validateSessionKey, (req, res) => {
    const query = 'SELECT name, nickname, credits FROM Members';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }
        res.status(200).json(results);
    });
});
/**
 * @swagger
 * /api/getRole:
 *   get:
 *     summary: Retrieve the role from a member/admin
 *     description: Retrieve a list of all members from the database
 *     parameters:
 *      - in: header
 *        name: auth
 *        schema:
 *          type: string
 *        required: true
 *        description: Session key of the user to retrieve
 *     responses:
 *       200:
 *         description: A JSON array of the role of a member
 *       500:
 *         description: Internal server error
 */
app.get('/api/getRole', validateSessionKey, (req, res) => {
    const sessionKey = req.headers.auth;
    const sessionQuery = `SELECT rt.role_type
                          FROM Session s
                          JOIN Members m ON s.member_id = m.member_id
                          JOIN RoleTypes rt ON m.role_id = rt.role_id
                          WHERE s.session_key = ?`;
    connection.query(sessionQuery, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        var role = results[0].role_type;
        res.status(201).json({ role: role });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

