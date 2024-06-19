const express = require('express');
const router = express.Router();
const connection = require('../config/db');
const validateSessionKey = require('../middleware/validate-sessionkey');
const deleteSessionKey = require('../middleware/delete-sessionkey');

const crypto = require('crypto');

// Define autherisation routes
/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: Login to the application
 *     description: Authenticates a user and returns a session key
 *     consumes:
 *       - application/json
 *     produces:
 *       - application/json
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
router.post('/login', (req, res) => {
    const { nickname, password } = req.body;
    if (!nickname || !password) {
        return res.status(400).json({ error: 'Nickname and password are required' });
    }

    const query = 'SELECT * FROM Members WHERE nickname = ?';
    connection.query(query, [nickname], (err, results) => {
        if (err) {
            //console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0 || results[0].password !== password) {
            //console.error('Error authorizing: ', err);
            return res.status(401).json({ error: 'Incorrect nickname or password' });
        }

        const memberId = results[0].member_id;
        const sessionKey = crypto.randomBytes(16).toString('hex');

        const sessionQuery = 'INSERT INTO Session (session_key, member_id) VALUES (?, ?)';
        connection.query(sessionQuery, [sessionKey, memberId], (err) => {
            if (err) {
                //console.error('Error inserting session:', err);
                return res.status(500).json({ error: 'Internal server error' });
            }
            res.status(201).json({ session_key: sessionKey });
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
router.delete('/logout', deleteSessionKey, (req, res) => {
    res.status(200).json({ message: 'Logout successful' });
});
module.exports = router;
