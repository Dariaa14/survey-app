const authService = require('../services/authService');

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

module.exports = {
  login,
};