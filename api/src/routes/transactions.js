const express = require('express');
const router = express.Router();
const validateSessionKey = require('../middleware/validate-sessionkey');
const multer = require('multer');
const fs = require("fs");

const connection = require('../config/db');
const { excelImportPlayerCreditGeneral, excelImportDailyIncomeAndExpenses } = require('../middleware/parse-excel');
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
            //console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }
        
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
            //console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0) {
            return res.status(403).json({ error: 'Forbidden: User is not an admin or session not found' });
        }

        // Insert new transaction
        const insertTransactionQuery = `INSERT INTO Transactions (amount, description, date, member_id) VALUES (?, ?, ?, ?)`;

        connection.query(insertTransactionQuery, [amount, description, date, member_id], (err, results) => {
            if (err) {
                //console.error('Error executing MySQL query:', err);
                return res.status(500).json({ error: 'Internal server error' });
            }

            // Update credits in Members table
            const updateCreditsQuery = `UPDATE Members SET credits = credits + ? WHERE member_id = ?`;

            connection.query(updateCreditsQuery, [amount, member_id], (err, results) => {
                if (err) {
                    //console.error('Error executing MySQL query:', err);
                    return res.status(500).json({ error: 'Internal server error' });
                }

                res.status(201).json({ message: 'Transaction added successfully' });
            });
        });
    });
});

router.post('/upload-excel', validateSessionKey, upload.single('excelFile'), (req, res) => {
    const sessionKey = req.headers.auth;

    const filePath = req.file.path;
    const filteredDataPlayerCreditGeneral = excelImportPlayerCreditGeneral(filePath);
    const filteredDataDailyIncomeAndExpenses = excelImportDailyIncomeAndExpenses(filePath);

    var failedtransactionsPush = 0;

    filteredDataPlayerCreditGeneral.forEach(data => {
        if (data['Account name'] !== undefined || data['credit total'] !== undefined) {
            const updateCreditsQuery = `UPDATE Members SET credits = ? WHERE name = ?`;
            connection.query(updateCreditsQuery, [data['credit total'], data['Account name']], (err, results) => {
                if (err) {
                    //console.error('Error executing MySQL query:', err);
                    return res.status(500).json({ error: 'Internal server error' });
                }
            });
        } else {
            failedtransactionsPush++;
        }
    });

    const deleteTransactionQuery = `DELETE FROM Transactions`;
    connection.query(deleteTransactionQuery, (err, results) => {
        if (err) {
            //console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }
    });

    filteredDataDailyIncomeAndExpenses.forEach(data => {
        if (data['Player name'] !== undefined || data['Date'] !== undefined || data['Sale amount'] !== undefined || data['Discription'] !== undefined) {
            var currentMemberId = 0;
            const getMemberIdFromName = `SELECT member_id FROM Members WHERE name = ?`;
            connection.query(getMemberIdFromName, [data['Player Name']], (err, results) => {
                if (err) {
                    //console.error('Error executing MySQL query:', err);
                    return res.status(500).json({ error: 'Internal server error' });
                } else if (results[0] === null || results[0] === undefined) {
                    //console.log("Member id not found")                
                } else {
                    currentMemberId = results[0].member_id;
                    const updateTransactionsQuery = `INSERT INTO Transactions (amount, date, description, member_id) VALUES (?, ?, ?, ?)`;
                    connection.query(updateTransactionsQuery, [data['Sale amount'], data['Date'], data['Discription'], currentMemberId], (err, results) => {
                        if (err) {
                            console.error('Error executing MySQL query:', err);
                            return res.status(500).json({ error: 'Internal server error' });
                        }
                    });
                }
            });
        } else {
            failedtransactionsPush++;
        }
    });

    res.send('Excel file uploaded and parsed. Check the console for data. Failed transactions: ' + failedtransactionsPush);
    let resultHandler = function (err) {
        if (err) {
            //console.log("unlink failed", err);
        } else {
            //console.log("file deleted");
        }
    }
    fs.unlink(req.file.path, resultHandler);
    failedtransactionsPush = 0;
});

module.exports = router;
