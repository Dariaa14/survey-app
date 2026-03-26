const { DataTypes } = require('sequelize');
const { sequelize } = require('../db'); 

const Survey = sequelize.define('Survey', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        allowNull: false,
    },
    owner_id: {
        type: DataTypes.UUID,
        allowNull: false,
    },
    slug: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true,
    },
    title: {
        type: DataTypes.STRING(255),
        allowNull: false,
    },
    description: {
        type: DataTypes.TEXT,
        allowNull: true,
    },
    status: {
        type: DataTypes.ENUM('draft', 'published', 'closed'),
        allowNull: false,
        defaultValue: 'draft',
    },
    created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
    published_at: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
    },
    closed_at: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
    },
}, {
    tableName: 'surveys',
    timestamps: false, 
});

module.exports = { Survey };