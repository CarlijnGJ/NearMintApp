const express = require('express');
const cors = require('cors'); // only for localhost development
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swaggerOptions');
const { errorHandler } = require('./middleware/error-handler');
const authRouter = require('./routes/auth');
const membersRouter = require('./routes/members');
const rolesRouter = require('./routes/roles');

const app = express();

app.use(cors()); // only for localhost development
app.use(express.json());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use('/api', authRouter);
app.use('/api', membersRouter);
app.use('/api', rolesRouter);
app.use(errorHandler);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app;