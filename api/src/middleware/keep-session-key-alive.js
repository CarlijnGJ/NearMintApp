const connection = require('../config/db'); // Assuming you have a file named 'db.js' in the 'config' folder for database connection

/**
 * Middleware to validate session key
 */
function validateSessionKey(req, res, next) {
    const sessionKey = req.headers.auth;
    if (!sessionKey) {
        return res.status(401).json({ error: 'Unauthorized: No session key provided' });
    }

    const query = 'SELECT member_id FROM Session WHERE session_key = ?';
    connection.query(query, [sessionKey], (err, results) => {
        if (err) {
            console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }

        if (results.length === 0) {
            return res.status(401).json({ error: 'Unauthorized: Invalid session key' });
        }

        req.memberId = results[0].member_id;
        next();
    });
}

module.exports = validateSessionKey;
