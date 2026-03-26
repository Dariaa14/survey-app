const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const AnswerText = sequelize.define('AnswerText', {
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
    text_value: {
        type: DataTypes.TEXT,
        allowNull: true,
    },
}, {
    tableName: 'answers_text',
    timestamps: false,
});

module.exports = { AnswerText };