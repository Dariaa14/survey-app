const express = require('express');
const router = express.Router();

const { Survey } = require('../models/survey');
const { Question } = require('../models/question');
const { Option } = require('../models/option');

const models = require('../models/associations');

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


// GET by owner_id
router.get('/user/:ownerId', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { ownerId } = req.params;

        console.log('Fetching surveys for user ID:', ownerId);

        const surveys = await Survey.findAll({
            where: { owner_id: ownerId },
            include: [
                {
                    model: Question,
                    as: 'questions',       
                    include: [
                        {
                            model: Option,
                            as: 'options', 
                            order: [['order', 'ASC']] 
                        }
                    ]
                }
            ],
            order: [
                [{ model: Question, as: 'questions' }, 'order', 'ASC'],
                [{ model: Question, as: 'questions' }, { model: Option, as: 'options' }, 'order', 'ASC']
            ]
        });

        res.json(surveys);
    } catch (err) {
        console.error('Error fetching surveys:', err.stack);
        res.status(500).json({ error: 'Failed to fetch surveys for user' });
    }
});

// GET by ID
router.get('/:id', verifyToken, requireAdmin, async (req, res) => {
    try {
        const survey = await Survey.findByPk(req.params.id, {
            include: [
                {
                    model: Question,
                    include: [
                        {
                            model: Option
                        }
                    ]
                }
            ],
            order: [
                [Question, 'order', 'ASC'],
                [Question, Option, 'order', 'ASC']
            ]
        });

        if (!survey) {
            return res.status(404).json({ error: 'Survey not found' });
        }

        res.json(survey);
    } catch (err) {
        console.error('ERROR:', err.stack);
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

/// CREATE question
router.post('/:id/questions', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const {
            type,
            title,
            required,
            order,
            max_length,
            max_selections,
            options 
        } = req.body;

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        if (survey.status !== 'draft') {
            return res.status(400).json({ error: 'Can only add questions to draft surveys' });
        }

        const question = await Question.create({
            survey_id: id,
            type,
            title,
            required: required ?? false,
            order: order ?? 0,
            max_length,
            max_selections
        });

        if (options && Array.isArray(options)) {
            const optionData = options.map((opt, index) => ({
                question_id: question.id,
                label: opt.label,
                order: opt.order ?? index
            }));

            await Option.bulkCreate(optionData);
        }

        res.status(201).json(question);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to add question' });
    }
});

/// UPDATE question
router.put('/:id/questions/:qid', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id, qid } = req.params;

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        if (survey.status !== 'draft') {
            return res.status(400).json({ error: 'Can only edit draft surveys' });
        }

        const question = await Question.findByPk(qid);
        if (!question) return res.status(404).json({ error: 'Question not found' });

        await question.update(req.body);

        res.json(question);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update question' });
    }
});

///PUBLISH survey
router.post('/:id/publish', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        if (survey.status !== 'draft') {
            return res.status(400).json({ error: 'Only draft surveys can be published' });
        }

        const questionCount = await Question.count({
            where: { survey_id: id }
        });

        if (questionCount < 1) {
            return res.status(400).json({ error: 'Survey must have at least 1 question' });
        }

        await survey.update({
            status: 'published',
            published_at: new Date()
        });

        res.json({ message: 'Survey published' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to publish survey' });
    }
});

/// CLOSE survey
router.post('/:id/close', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        if (survey.status !== 'published') {
            return res.status(400).json({ error: 'Only published surveys can be closed' });
        }

        await survey.update({
            status: 'closed',
            closed_at: new Date()
        });

        res.json({ message: 'Survey closed' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to close survey' });
    }
});

module.exports = router;