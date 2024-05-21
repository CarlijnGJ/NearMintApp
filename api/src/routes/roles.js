const express = require('express');
const router = express.Router();
const validateSessionKey = require('../middleware/vallidate-sessionkey');
const connection = require('../config/db');

// Define role-related routes
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
router.get('/getRole', validateSessionKey, (req, res) => {
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

module.exports = router;
