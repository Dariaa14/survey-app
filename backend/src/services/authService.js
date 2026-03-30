
const bcrypt = require('bcrypt');
const db = require('../db'); 

async function login(email, password) {
  const result = await db.query(
    'SELECT * FROM users WHERE email = $1',
    [email]
  );

  const user = result.rows[0];
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
    JWT_SECRET,
    {
      expiresIn: JWT_EXPIRES_IN,
    }
  );

  return token;
}

module.exports = {
  login,
};