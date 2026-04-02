const express = require('express');
const router = express.Router();
const { Op } = require('sequelize');

const {
    Invitation,
    Survey,
    EmailList,
    EmailContact
} = require('../models');

const { generatePublicToken, hashToken } = require('../services/tokenService');

const { verifyToken } = require('../utils/authMiddleware');
const { requireAdmin } = require('../utils/adminMiddleware');

/// CREATE
router.post('/:id/invitations/send', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { list_id } = req.body;

        if (!list_id) {
            return res.status(400).json({ error: 'list_id is required' });
        }

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        const contacts = await EmailContact.findAll({
            where: { list_id }
        });

        const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            attributes: ['contact_id']
        });

        const existingSet = new Set(existingInvites.map(i => i.contact_id));

        const toInsert = [];
        const emailPayload = []; 

        let skipped = 0;

        for (const c of contacts) {
            if (existingSet.has(c.id)) {
                skipped++;
                continue;
            }

            const rawToken = generatePublicToken();
            const tokenHash = hashToken(rawToken);

            toInsert.push({
                survey_id: id,
                contact_id: c.id,
                token_hash: tokenHash
            });

            emailPayload.push({
                email: c.email,
                name: c.name,
                token: rawToken
            });
        }

        if (toInsert.length > 0) {
            await Invitation.bulkCreate(toInsert, {
                ignoreDuplicates: true
            });
        }

        console.log('Emails to send:', emailPayload.length);

        res.status(201).json({
            inserted: toInsert.length,
            skipped
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to send invitations' });
    }
});

/// GET by survey_id
router.get('/:id/invitations', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { page = 1, q } = req.query;

        const limit = 20;
        const offset = (page - 1) * limit;

        const include = [
            {
                model: EmailContact,
                as: 'contact',
                attributes: ['email', 'name'],
                where: q
                    ? {
                          email: {
                              [Op.iLike]: `%${q}%`
                          }
                      }
                    : undefined
            }
        ];

        const { count, rows } = await Invitation.findAndCountAll({
            where: { survey_id: id },
            include,
            limit,
            offset,
            order: [['created_at', 'DESC']]
        });

        res.json({
            total: count,
            page: parseInt(page),
            pages: Math.ceil(count / limit),
            data: rows
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch invitations' });
    }
});

/// PREVIEW
router.get('/:id/invitations/preview', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { list_id } = req.query;

        if (!list_id) {
            return res.status(400).json({ error: 'list_id is required' });
        }

        const contacts = await EmailContact.findAll({
            where: { list_id },
            attributes: ['id']
        });

        const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            attributes: ['contact_id']
        });

        const existingSet = new Set(existingInvites.map(i => i.contact_id));

        let newCount = 0;
        let skipped = 0;

        contacts.forEach(c => {
            if (existingSet.has(c.id)) {
                skipped++;
            } else {
                newCount++;
            }
        });

        res.json({
            total: contacts.length,
            new: newCount,
            skipped
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to preview invitations' });
    }
});

module.exports = router;