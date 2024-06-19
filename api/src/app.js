const express = require('express');
const { errorHandler } = require('./middleware/error-handler');
const authRouter = require('./routes/auth');
const membersRouter = require('./routes/members');
const rolesRouter = require('./routes/roles');
const addmemberRouter = require('./routes/addmember');
const updatememberRouter = require('./routes/updatemember');
const keepSessionKeyAlive = require('./routes/keep-sessionkey-alive');
const transactionRouter = require('./routes/transactions');


const app = express();

// Only for localhost development
if (process.env.NODE_ENV === 'development') {
    const swaggerUi = require('swagger-ui-express');
    const swaggerSpec = require('./config/swaggerOptions');
    app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
}
const cors = require('cors'); 

app.use(cors());
app.use(express.json()); // Middleware to parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Middleware to parse URL-encoded bodies

app.use('/api', authRouter);
app.use('/api', membersRouter);
app.use('/api', rolesRouter);
app.use('/api', addmemberRouter);
app.use('/api', updatememberRouter);
app.use('/api', keepSessionKeyAlive);
app.use('/api', transactionRouter);
app.use(errorHandler);

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = server;
