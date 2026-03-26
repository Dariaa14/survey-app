const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const Option = sequelize.define('Option', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    question_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    label: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    order: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
}, {
    tableName: 'options',
    timestamps: false,
});

module.exports = { Option };