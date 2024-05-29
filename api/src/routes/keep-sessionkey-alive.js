const express = require('express');
const router = express.Router();
const validateSessionKey = require('../middleware/validate-sessionkey');
const connection = require('../config/db');

/**
 * @swagger
 * /api/keepSessionKeyAlive:
 *   put:
 *     summary: Update the last updated timestamp of a session key
 *     description: Update the last updated timestamp of the session key provided in the request header.
 *     parameters:
 *      - in: header
 *        name: auth
 *        schema:
 *          type: string
 *        required: true
 *        description: Session key of the user to update
 *     responses:
 *       201:
 *         description: Successfully updated the session key
 *       404:
 *         description: Session not found
 *       500:
 *         description: Internal server error
 */ 
router.put('/keepSessionKeyAlive', validateSessionKey, (req, res) => {
    const sessionKey = req.headers.auth;
    const sessionQuery = `UPDATE Session SET last_updated = NOW() WHERE session_key = ?`;
    connection.query(sessionQuery, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Session not found' });
        }
        res.status(201).end();
    });
});


module.exports = router;
