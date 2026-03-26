const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const Response = sequelize.define('Response', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    survey_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    invitation_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    submitted_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
}, {
    tableName: 'responses',
    timestamps: false,
});

module.exports = { Response };