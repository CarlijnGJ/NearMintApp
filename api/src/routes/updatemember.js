const express = require('express');
const router = express.Router();
const connection = require('../config/db'); // Ensure this is the correct path to your DB config

/**
 * @swagger
 * /api/editmember:
 *  post:
 *    summary: Update member data in the database
 *    description: Update an existing member's data in the database
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              member_id:
 *                type: string
 *              nickname:
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
router.post('/editmember', (req, res) => {
    const { member_id, nickname, avatar, gender, prefgame } = req.body;

    console.log('Request body:', req.body);

    if (!member_id) {
        return res.status(400).json({ error: 'Member ID is required' });
    }

    let dataQuery = 'UPDATE Members SET';
    const queryParams = [];
    const queryValues = [];

    if (nickname) {
        queryParams.push('nickname = ?');
        queryValues.push(nickname);
    }

    if (avatar) {
        queryParams.push('avatar = ?');
        queryValues.push(avatar);
    }

    if (gender) {
        queryParams.push('gender = ?');
        queryValues.push(gender);
    }

    if (prefgame) {
        queryParams.push('preferedgame = ?');
        queryValues.push(prefgame);
    }

    if (queryParams.length === 0) {
        return res.status(400).json({ error: 'No data provided for update' });
    }

    dataQuery += ' ' + queryParams.join(', ');
    dataQuery += ' WHERE member_id = ?';
    queryValues.push(member_id);

    console.log('SQL Query:', dataQuery);
    console.log('Query Values:', queryValues);

    connection.query(dataQuery, queryValues, (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        res.status(200).json({
            result: true
        });
    });
});


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
        return res.status(400).json({ error: 'Nickname and password are required' });
    }
    try {
        const dataQuery = 'INSERT INTO Members (name, nickname, password, avatar, gender, preferedgame, role_id) SELECT name, ? AS nickname, ? AS password, ? as avatar, ? AS gender, ? as preferedgame, 1 FROM NewMembers WHERE secret = ?';
        connection.query(dataQuery, [nickname, password, avatar, gender, prefgame, code], (err, results) => {
            if (err) {
                //console.error('Error executing MySQL query:', err);
                return res.status(500).json({ error: 'Internal server error' });
            } else {
                // Continue with other operations (e.g., deleting from NewMembers table)
                const removeQuery = 'DELETE FROM NewMembers WHERE secret = ?';
                connection.query(removeQuery, [code], (err, results) => {
                    if (err) {
                        //console.error('Error executing MySQL query:', err);
                        return res.status(500).json({ error: 'Internal server error' });
                    }

                    // Final response
                    return res.status(200).json({ result: true });
                });
            }
        });
    }
    catch (err) {
        //console.error('Error executing MySQL query:', err);
        return res.status(503).json({ error: 'Duplicate field entry' });
    }
});


module.exports = router;