const express = require('express');
const router = express.Router();
const validateSessionKey = require('../middleware/validate-sessionkey');
const connection = require('../config/db');

// Define member-related routes
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
router.get('/member', validateSessionKey, (req, res) => {
    const memberId = req.memberId;

    const memberQuery = 'SELECT nickname, name, avatar, gender, preferedgame FROM Members WHERE member_id = ?';
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
            avatar: results[0].avatar,
            gender: results[0].gender,
            preferedGame: results[0].preferedgame
        });
    });
});

/**
 * @swagger
 * /api/member/code:
 *   get:
 *     summary: Retrieve all member codes
 *     description: Retrieve a list of codes for new members from the database
 *     parameters:
 *      - in: header
 *        name: code
 *        schema:
 *          type: string
 *        required: true
 *        description: Code to match against the others
 *     responses:
 *       200:
 *         description: A JSON array of member objects
 *       500:
 *         description: Internal server error
 */
router.get('/member/code', (req, res) => {
    const parameter = req.headers.code;
    const codeQuery = 'SELECT secret, name FROM NewMembers WHERE secret = ?';

    if (!parameter) {
        return res.status(400).json({ error: 'Code header is required' });
    }

    connection.query(codeQuery, [parameter], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length != 0) {
            console.log("True");
            res.status(200).json({ result: true, name: results[0].name });
        } else {
            console.log("False");
            res.status(200).json({ result: false, name: 'null' });
        }
    });
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
router.get('/members', validateSessionKey, (req, res) => {
    const query = 'SELECT * FROM Members';
    connection.query(query, (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }
        res.status(200).json(results);
    });
});

module.exports = router;
