const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { User } = require('../models/user');
const userController = require('../controllers/userController');

const { verifyToken } = require('../utils/authMiddleware');

// CREATE
router.post('/', async (req, res) => {
    try {
        const { email, password, type } = req.body;

        if (!email || !password || !type) {
            return res.status(400).json({ error: 'email, password, and type are required' });
        }

        const password_hash = await bcrypt.hash(password, 10);

        const user = await User.create({
            email,
            password_hash,
            type,
        });


        const userData = {
            id: user.id,
            email: user.email,
            type: user.type,
            created_at: user.created_at,
        };

        res.status(201).json(userData);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to create user' });
    }
});

// GET 
router.get('/', async (req, res) => {
    try {
        const users = await User.findAll({
            attributes: ['id', 'email', 'type', 'created_at']
        });
        res.json(users);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch users' });
    }
});

// GET current authenticated user
router.get('/me', verifyToken, userController.getCurrentUser);

// GET by ID
router.get('/:id', async (req, res) => {
    try {
        const user = await User.findByPk(req.params.id, {
            attributes: ['id', 'email', 'type', 'created_at']
        });
        if (!user) return res.status(404).json({ error: 'User not found' });
        res.json(user);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch user' });
    }
});


// LOGIN
router.post('/login', userController.login);

module.exports = router;