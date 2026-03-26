const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const AnswerChoice = sequelize.define('AnswerChoice', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    response_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    question_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    option_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
}, {
    tableName: 'answers_choice',
    timestamps: false,
});

module.exports = { AnswerChoice };