
const bcrypt = require('bcrypt');
const db = require('../db'); 
const { User}  = require('../models/user');
const jwt = require('jsonwebtoken');

async function login(email, password) {
  const user = await User.findOne({
      where: { email },           
      attributes: ['id', 'email', 'password_hash', 'type', 'created_at']
    });

  if (!user) {
    throw new Error('Invalid credentials');
  }

  const isValid = await bcrypt.compare(password, user.password_hash);

  if (!isValid) {
    throw new Error('Invalid credentials');
  }

  const token = jwt.sign(
    {
      userId: user.id,
      email: user.email,
      type: user.type,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN,
    }
  );

  return token;
}

module.exports = {
  login,
};