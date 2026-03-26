const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const Question = sequelize.define('Question', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    survey_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    type: {
        type: 'question_type',
        allowNull: false,
    },
    title: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    required: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
    },
    order: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    max_length: {
        type: DataTypes.INTEGER,
        allowNull: true, 
        defaultValue: 1000,
    },
    max_selections: {
        type: DataTypes.INTEGER,
        allowNull: true,
    },
}, {
    tableName: 'questions',
    timestamps: false,
});

module.exports = { Question };