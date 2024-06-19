const connection = require('../config/db'); // Assuming you have a file named 'db.js' in the 'config' folder for database connection

/**
 * Middleware to delete session key
 */
function deleteSessionKey(req, res, next) {
    const sessionKey = req.headers.auth;

    if (!sessionKey) {
        return res.status(400).json({ error: 'Session key not provided in header' });
    }

    const deleteQuery = 'DELETE FROM Session WHERE session_key = ?';
    connection.query(deleteQuery, [sessionKey], (err, results) => {
        if (err) {
            //console.error('Error executing MySQL query:', err);
            return res.status(500).json({ error: 'Internal server error' });
        }   

        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'Session key not found' });
        }

        // Session key successfully deleted
        next();
    });
}

module.exports = deleteSessionKey;
