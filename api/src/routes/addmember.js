const express = require('express');
const router = express.Router();
const connection = require('../config/db'); // Ensure this is the correct path to your DB config

// Define member-related routes
/**
 * @swagger
 * /api/addmember:
 *  post:
 *    summary: Insert a new member into the database
 *    description: Insert a new member into the database
 *    requestBody:
 *      required: true
 *      content:
 *        application/json:
 *          schema:
 *            type: object
 *            properties:
 *              name:
 *                type: string
 *              mail:
 *                type: string
 *              phonenumber:
 *                type: string
 *              secret:
 *                type: string
 *    responses:
 *      200:
 *        description: Successful operation
 *        content:
 *          application/json:
 *            schema:
 *              type: object
 *              properties:
 *                name:
 *                  type: string
 *                  description: The name of the new member
 *                mail:
 *                  type: string
 *                  description: The email of the new member
 *                phonenumber:
 *                  type: string
 *                  description: The phone number of the new member
 *                secret:
 *                  type: string
 *                  description: The secret for the new member
 *      400:
 *        description: Bad request
 *      500:
 *        description: Internal server error
 */
router.post('/addmember', (req, res) => {
    const { name, mail, phonenumber, secret } = req.body;

    if (!name || !mail || !phonenumber || !secret) {
        return res.status(400).json({ error: 'All fields are required: ' + name + mail + phonenumber + secret });
    }

    const insertQuery = 'INSERT INTO NewMembers (name, email, phonenumber, secret) VALUES (?, ?, ?, ?)';
    connection.query(insertQuery, [name, mail, phonenumber, secret], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        res.status(200).json({
            name: name,
            mail: mail,
            phonenumber: phonenumber,
            secret: secret
        });
    });
});

module.exports = router;
