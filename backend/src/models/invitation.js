const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const Invitation = sequelize.define('Invitation', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    survey_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    contact_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    token_hash: {
        type: DataTypes.STRING(64),
        allowNull: false,
    },
    sent_at: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    email_opened_at: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    survey_opened_at: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    submitted_at: {
        type: DataTypes.DATE,
        allowNull: true,
    },
    bounced_at: {
        type: DataTypes.DATE,
        allowNull: true,
    },
}, {
    tableName: 'invitations',
    timestamps: false,
});

module.exports = { Invitation };