const express = require('express');
const router = express.Router();

const { Survey } = require('../models/survey');
const { Question } = require('../models/question');
const { Option } = require('../models/option');
const { User } = require('../models/user');
const models = require('../models/associations');

const { getSurveyStatsAttributes } = require('../controllers/surveyController');

const { sequelize } = require('../db');
const { Op } = require('sequelize');

const { requireAdmin } = require('../utils/adminMiddleware');
const { verifyAuthToken } = require('../utils/authMiddleware');
const { validateToken } = require('../utils/tokenValidation');


// CREATE 
router.post('/', verifyAuthToken, requireAdmin, async (req, res) => {
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
        console.log(err);
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
router.get('/user/:ownerId', verifyAuthToken, requireAdmin, async (req, res) => {
    try {
        const { ownerId } = req.params;
        const { status } = req.query;

        const where = { owner_id: ownerId };

        if (status) {
            where.status = status;
        }

        const surveys = await Survey.findAll({
            where: where,
            attributes: {
                include: getSurveyStatsAttributes()
            },
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

        console.log(`Fetched ${surveys.length} surveys for user ${ownerId} with status filter: ${status || 'none'}`);

        res.json(surveys);
    } catch (err) {
        console.log(err);
        console.error('Error fetching surveys:', err.stack);
        res.status(500).json({ error: 'Failed to fetch surveys for user', err });
    }
});

// GET by slug
router.get('/s/:slug', validateToken, async (req, res) => {
    try {
        const { slug } = req.params;

        const survey = await Survey.findOne({
            where: { slug },
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
                    ],
                    order: [['order', 'ASC']]
                }
            ]
        });

        if (!survey) {
            return res.status(404).json({ error: 'Survey not found' });
        }

        res.json(survey);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch survey' });
    }
});

// GET by ID
router.get('/:id', verifyAuthToken, requireAdmin, async (req, res) => {
    try {
        const survey = await Survey.findByPk(req.params.id, {
            attributes: {
                include: getSurveyStatsAttributes()
            },
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
router.put('/:id', verifyAuthToken, requireAdmin, async (req, res) => {
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
router.delete('/:id', verifyAuthToken, requireAdmin, async (req, res) => {
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
router.post('/:id/questions', verifyAuthToken, requireAdmin, async (req, res) => {
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
router.put('/:id/questions/:qid', verifyAuthToken, requireAdmin, async (req, res) => {
    const t = await sequelize.transaction();

    try {
        const { id, qid } = req.params;
        const {
            title,
            type,
            required,
            order,
            max_length,
            max_selections,
            options
        } = req.body;

        const survey = await Survey.findByPk(id, { transaction: t });
        if (!survey) {
            await t.rollback();
            return res.status(404).json({ error: 'Survey not found' });
        }

        if (survey.status !== 'draft') {
            await t.rollback();
            return res.status(400).json({ error: 'Can only edit draft surveys' });
        }

        const question = await Question.findByPk(qid, { transaction: t });
        if (!question) {
            await t.rollback();
            return res.status(404).json({ error: 'Question not found' });
        }

        await question.update({
            title,
            type,
            required,
            order,
            max_length,
            max_selections
        }, { transaction: t });

        if (type === 'multiple_choice' && Array.isArray(options)) {

            await Option.destroy({
                where: { question_id: qid },
                transaction: t
            });

            const newOptions = options.map((opt, index) => ({
                question_id: qid,
                label: opt.label,
                order: opt.order ?? index
            }));

            await Option.bulkCreate(newOptions, { transaction: t });
        }

        await t.commit();

        const updatedQuestion = await Question.findByPk(qid, {
            include: [{ model: Option, as: 'options' }]
        });

        res.json(updatedQuestion);

    } catch (err) {
        console.log(err);
        await t.rollback();
        console.error(err);
        res.status(500).json({ error: 'Failed to update question: ', message: err.message });
    }
});

router.delete('/:id/questions/:qid', verifyAuthToken, requireAdmin, async (req, res) => {
    try {
        const { qid } = req.params;

        const question = await Question.findByPk(qid);

        if (!question) {
            return res.status(404).json({ error: 'Question not found' });
        }

        await question.destroy();

        res.json({ message: 'Question deleted successfully' });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to delete question' });
    }
});

///PUBLISH survey
router.post('/:id/publish', verifyAuthToken, requireAdmin, async (req, res) => {
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
router.post('/:id/close', verifyAuthToken, requireAdmin, async (req, res) => {
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