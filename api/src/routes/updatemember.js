const express = require('express');
const router = express.Router();
const connection = require('../config/db'); // Ensure this is the correct path to your DB config

/**
 * @swagger
 * /api/updatemember:
 *  post:
 *    summary: Update member data in database
 *    description: Update a member's data in the database according to their code
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              code:
 *                type: string
 *              nickname:
 *                type: string
 *              password:
 *                type: string
 *              avatar:
 *                type: string
 *              gender:
 *                type: string
 *              prefgame:
 *                type: string
 *    responses:
 *      200:
 *        description: Successful operation
 *      400:
 *        description: Bad request
 *      500:
 *        description: Internal server error
 */
router.post('/updatemember', (req, res) => {
    const { code, nickname, password, avatar, gender, prefgame } = req.body;

    if (!code || !nickname || !password) {
        return res.status(400).json({ error: 'Nickname and password are required: ' + code + nickname + password });
    }

    const dataQuery = 'INSERT INTO Members (name, nickname, password, avatar, gender, preferedgame, role_id) SELECT name, ? AS nickname, ? AS password, ? as avatar, ? AS gender, ? as preferedgame, 1 FROM NewMembers WHERE secret = ?';
    connection.query(dataQuery, [nickname, password, avatar, gender, prefgame, code], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        res.status(200).json({
            result: true
        });
    });
});

module.exports = router;