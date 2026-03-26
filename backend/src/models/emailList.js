const { DataTypes } = require('sequelize');
const { sequelize } = require('../db');

const EmailList = sequelize.define('EmailList', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    owner_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    name: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
    },
}, {
    tableName: 'email_lists',
    timestamps: false,
});

module.exports = { EmailList };