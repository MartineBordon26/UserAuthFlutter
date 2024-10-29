// src/config/database.js
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: './src/data/database.sqlite',
});

module.exports = sequelize;
