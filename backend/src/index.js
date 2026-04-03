const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();



app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.send('SurveyApp API is running');
});

// Routes
const userRoutes = require('./routes/userRoutes');
app.use('/api/users', userRoutes);

const surveyRoutes = require('./routes/surveyRoutes');
app.use('/api/surveys', surveyRoutes);

const emailListRoutes = require('./routes/emailListRoutes');
app.use('/api/email-lists', emailListRoutes);

const invitationRoutes = require('./routes/invitationRoutes');
app.use('/api/surveys', invitationRoutes);

const webhookRoutes = require('./routes/webhookRoutes');
app.use('/webhooks', webhookRoutes);

const trackingRoutes = require('./routes/trackingRoutes');
app.use('/t', trackingRoutes);

// DB
const { sequelize } = require('./db');
const models = require('./models');

const PORT = process.env.PORT || 3000;

const startServer = async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected');

        await sequelize.sync({ alter: true });
        console.log('All models synced');

        app.listen(PORT, () => {
            console.log(`Server is running on port ${PORT}`);
        });

        setInterval(() => console.log('Server still running...'), 30000);

    } catch (err) {
        console.error('Failed to start server:', err);
    }
};

startServer();

// Global error handlers
process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION:', err);
});

process.on('unhandledRejection', (err) => {
  console.error('UNHANDLED REJECTION:', err);
});
