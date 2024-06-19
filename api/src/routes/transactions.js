const express = require('express');
const router = express.Router();
const validateSessionKey = require('../middleware/validate-sessionkey');
const parseExcel = require('../middleware/parse-excel').default;
const multer = require('multer');
const fs = require("fs");

const connection = require('../config/db');
const parsingExcelFile = require('../middleware/parse-excel');
const upload = multer({ dest: 'uploads/' });

// Define transaction-related routes

/**
 * @swagger
 * /api/getTransactions:
 *   get:
 *     summary: Retrieve the transactions of a member
 *     description: Retrieve a list of all transactions for a member from the database
 *     parameters:
 *      - in: header
 *        name: auth
 *        schema:
 *          type: string
 *        required: true
 *        description: Session key of the user to retrieve transactions
 *     responses:
 *       200:
 *         description: A JSON array of the transactions of a member
 *       404:
 *         description: User not found or no transactions available
 *       500:
 *         description: Internal server error
 */
router.get('/getTransactions', validateSessionKey, (req, res) => {
    const sessionKey = req.headers.auth;
    const sessionQuery = `SELECT t.amount, t.description, t.date
                          FROM Session s
                          JOIN Members m ON s.member_id = m.member_id
                          JOIN Transactions t ON m.member_id = t.member_id
                          WHERE s.session_key = ?`;

    connection.query(sessionQuery, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        // if (results.length === 0) {
        //     return res.status(404).json({ error: 'User not found or no transactions available' });
        // }

        res.status(200).json({ transactions: results });
    });
});

/**
 * @swagger
 * /api/addTransaction:
 *   post:
 *     summary: Add a new transaction for a member
 *     description: Add a new transaction for the member associated with the provided session key
 *     parameters:
 *       - in: header
 *         name: auth
 *         schema:
 *           type: string
 *         required: true
 *         description: Session key of the user to add transaction for
 *       - in: body
 *         name: transaction
 *         description: Transaction details
 *         required: true
 *         schema:
 *           type: object
 *           properties:
 *             member_id:
 *               type: integer
 *               description: ID of the member to add transaction for
 *             amount:
 *               type: number
 *               description: Amount of the transaction
 *             description:
 *               type: string
 *               description: Description of the transaction
 *             date:
 *               type: string
 *               format: date-time
 *               description: Date of the transaction in ISO 8601 format
 *     responses:
 *       201:
 *         description: Transaction added successfully
 *       400:
 *         description: Bad request
 *       500:
 *         description: Internal server error
 */
router.post('/addTransaction', validateSessionKey, (req, res) => {
    const sessionKey = req.headers.auth;
    const { member_id, amount, description, date } = req.body;

    if (!member_id || !amount || !date) {
        return res.status(400).json({ error: 'Member ID, amount, and date are required' });
    }

    // Retrieve role and member_id from session using the session key
    const getRoleQuery = `
    SELECT u.member_id, ur.role_id
    FROM Session s
    JOIN Members u ON s.member_id = u.member_id
    JOIN RoleTypes ur ON u.role_id = ur.role_id
    WHERE s.session_key = ? AND ur.role_id = 2`;
    connection.query(getRoleQuery, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0) {
            return res.status(403).json({ error: 'Forbidden: User is not an admin or session not found' });
        }

        // Insert new transaction
        const insertTransactionQuery = `INSERT INTO Transactions (amount, description, date, member_id) VALUES (?, ?, ?, ?)`;

        connection.query(insertTransactionQuery, [amount, description, date, member_id], (err, results) => {
            if (err) {
                console.error('Error executing MySQL query:', err);
                return res.status(500).json({ error: 'Internal server error' });
            }

            // Update credits in Members table
            const updateCreditsQuery = `UPDATE Members SET credits = credits + ? WHERE member_id = ?`;

            connection.query(updateCreditsQuery, [amount, member_id], (err, results) => {
                if (err) {
                    console.error('Error executing MySQL query:', err);
                    return res.status(500).json({ error: 'Internal server error' });
                }

                res.status(201).json({ message: 'Transaction added successfully' });
            });
        });
    });
});

router.post('/upload-excel', upload.single('excelFile'), (req, res) => {
    const filePath = req.file.path;
    const filteredData = parsingExcelFile(filePath);
    
    var failedtransactionsPush = 0;

    filteredData.forEach(data => {
        if (data.__EMPTY !== undefined || data.__EMPTY_1 !== undefined) {
        const insertTransactionQuery = `INSERT INTO NearMintGamingDB.TestTransactions (member_name, credit_total) VALUES (?, ?)`;
        connection.query(insertTransactionQuery, [data.__EMPTY, data.__EMPTY_1], (err, results) => {
            if (err) {
                console.error('Error executing MySQL query:', err);
                return res.status(500).json({ error: 'Internal server error' });
            }
        });
        } else {
            failedtransactionsPush++;
        }
    });
    res.send('Excel file uploaded and parsed. Check the console for data. Failed transactions: ' + failedtransactionsPush);
    let resultHandler = function (err) {
        if (err) {
            console.log("unlink failed", err);
        } else {
            console.log("file deleted");
        }
    }
    fs.unlink(req.file.path, resultHandler);
    failedtransactionsPush = 0;
});

module.exports = router;
