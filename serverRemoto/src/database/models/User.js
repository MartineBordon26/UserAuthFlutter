const {Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database');


class User extends Model {}

User.init({
    _id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    username: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
    },
}, {
  sequelize,
  modelName: 'User',
});

module.exports = User;