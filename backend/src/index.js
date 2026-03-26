const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
    res.send('SurveyApp API is running');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

/// Models and DB
const { sequelize } = require('./db');
const models = require('./models'); 

(async () => {
    try {
        await sequelize.authenticate();
        console.log('Database connected');
        await sequelize.sync({ alter: true });
        console.log('All models synced');
    } catch (err) {
        console.error(err);
    }
})();

/// Routes 
const userRoutes = require('./routes/userRoutes');
app.use('/api/users', userRoutes);

const surveyRoutes = require('./routes/surveyRoutes');
app.use('/api/surveys', surveyRoutes);