const express = require('express');
const router = express.Router();
const { Survey } = require('../models/survey');
const { requireAdmin } = require('../utils/adminMiddleware');
const { verifyToken } = require('../utils/authMiddleware');


// CREATE 
router.post('/', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { owner_id, title, description, slug, status } = req.body;

        if (!owner_id || !title || !slug) {
            return res.status(400).json({ error: 'owner_id, title, and slug are required' });
        }

        const owner = await User.findByPk(owner_id);
        if (!owner) return res.status(404).json({ error: 'Owner user not found' });

        const validStatuses = ['draft', 'published', 'closed'];
        const surveyStatus = status && validStatuses.includes(status) ? status : 'draft';

        const survey = await Survey.create({
            owner_id,
            title,
            description,
            slug,
            status: surveyStatus,       
            created_at: new Date() 
        });

        res.status(201).json(survey);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to create survey' });
    }
});

// GET 
router.get('/', async (req, res) => {
    try {
        const surveys = await Survey.findAll();
        res.json(surveys);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch surveys' });
    }
});

// GET by ID
router.get('/:id',verifyToken, requireAdmin, async (req, res) => {
    try {
        const survey = await Survey.findByPk(req.params.id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });
        res.json(survey);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch survey' });
    }
});

// GET by owner_id
router.get('/user/:ownerId',verifyToken, requireAdmin, async (req, res) => {
    try {
        const { ownerId } = req.params;

        const surveys = await Survey.findAll({
            where: { owner_id: ownerId },
            order: [['created_at', 'DESC']],
        });

        res.json(surveys);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch surveys for user' });
    }
});


// UPDATE by ID
router.put('/:id',verifyToken, requireAdmin, async (req, res) => {
    try {
        const { title, description, slug, status, published_at, closed_at } = req.body;
        const survey = await Survey.findByPk(req.params.id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        await survey.update({ title, description, slug, status, published_at, closed_at });
        res.json(survey);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update survey' });
    }
});

// DELETE by ID
router.delete('/:id',verifyToken, requireAdmin, async (req, res) => {
    try {
        const survey = await Survey.findByPk(req.params.id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        await survey.destroy();
        res.json({ message: 'Survey deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to delete survey' });
    }
});

module.exports = router;