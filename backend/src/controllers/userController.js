const authService = require('../services/authService');
const User = require('../models/user');

async function login(req, res) {
  try {
    const { email, password } = req.body;

    const token = await authService.login(email, password);

    res.json({
      message: 'Login successful',
      token,
    });
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
}

async function getCurrentUser(req, res) {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      return res.status(401).json({ error: 'Invalid token payload' });
    }

    const user = await User.findByPk(userId, {
      attributes: ['id', 'email', 'type', 'created_at'],
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json(user);
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch current user' });
  }
}

module.exports = {
  login,
  getCurrentUser,
};