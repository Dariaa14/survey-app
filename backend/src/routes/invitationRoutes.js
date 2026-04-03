const express = require('express');
const router = express.Router();
const { Op } = require('sequelize');

const pLimit = require('p-limit').default;
const sendEmail = require('../services/emailService').sendEmail;

const {
    Invitation,
    Survey,
    EmailList,
    EmailContact
} = require('../models');

const { generatePublicToken, hashToken } = require('../services/tokenService');

const { verifyToken } = require('../utils/authMiddleware');
const { requireAdmin } = require('../utils/adminMiddleware');

/// CREATE and SEND
router.post('/:id/invitations/send', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { list_id } = req.body;

        if (!list_id) {
            return res.status(400).json({ error: 'list_id is required' });
        }

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        // Get all contacts in the list
        const contacts = await EmailContact.findAll({
            where: { list_id },
            attributes: ['id', 'email', 'name']
        });

        // Get all emails already invited for this survey
        const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            include: [{
                model: EmailContact,
                as: 'contact',
                attributes: ['email']
            }]
        });

        const existingEmailSet = new Set(
            existingInvites.map(inv => inv.contact.email)
        );

        const toInsert = [];
        const emailPayload = [];
        let skipped = 0;

        for (const c of contacts) {
            if (existingEmailSet.has(c.email)) {
                skipped++;
                continue;
            }

            const rawToken = generatePublicToken();
            const tokenHash = hashToken(rawToken);

            toInsert.push({
                survey_id: id,
                contact_id: c.id,
                token_hash: tokenHash,
                sent_at: new Date()
            });

            emailPayload.push({
                email: c.email,
                name: c.name,
                token: rawToken
            });
        }

        // Insert new invitations
        if (toInsert.length > 0) {
            await Invitation.bulkCreate(toInsert, {
                ignoreDuplicates: true
            });
        }

        console.log('Emails to send:', emailPayload.length);

        // Parallel sending
        const limit = pLimit(5);

        await Promise.all(
            emailPayload.map(payload =>
                limit(async () => {
                    const surveyLink = `http://localhost:3000/survey/${survey.id}?t=${payload.token}`;

                    await sendEmail({
                        to: payload.email,
                        subject: `You're invited to: ${survey.title}`,
                        html: `
                            <p>Hi ${payload.name || ''},</p>
                            <p>You are invited to take the survey:</p>
                            <p><strong>${survey.title}</strong></p>
                            <a href="${surveyLink}">Take Survey</a>

                            <!-- Tracking pixel -->
                            <img src="http://localhost:3000/t/open/${payload.token}.png"
                                width="1" height="1"
                                style="display:block;"
                                alt="" />
                        `
                    });
                })
            )
        );

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
        const { q } = req.query;

        const include = [
            {
                model: EmailContact,
                as: 'contact',
                where: q
                    ? {
                          email: {
                              [Op.iLike]: `%${q}%`
                          }
                      }
                    : undefined
            }
        ];

        const invitations = await Invitation.findAll({
            where: { survey_id: id },
            include,
            order: [['sent_at', 'DESC']]
        });

        res.json(invitations);

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
            attributes: ['id', 'email']
        });

         const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            include: [{
                model: EmailContact,
                as: 'contact',
                attributes: ['email']
            }]
        });

        const existingSet = new Set(existingInvites.map(i => i.contact.email));

        let newCount = 0;
        let skipped = 0;

        contacts.forEach(c => {
            if (existingSet.has(c.email)) {
                skipped++;
            } else {
                newCount++;
            }
        });

        res.json({
            new: newCount,
            skipped
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to preview invitations' });
    }
});

module.exports = router;