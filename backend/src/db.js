const { Sequelize } = require('sequelize');
const { Pool } = require('pg');
require('dotenv').config({ path: '../.env' });

const sequelize = new Sequelize(
    process.env.DB_NAME,     
    process.env.DB_USER,     
    process.env.DB_PASSWORD, 
    {
        host: process.env.DB_HOST,
        dialect: 'postgres', 
        logging: false,   
    }
);

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

module.exports = { sequelize, pool };

(async () => {
    try {
        await sequelize.authenticate();
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
})();

