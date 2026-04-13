const express = require('express');
const router = express.Router();
const { Op } = require('sequelize');

const pLimit = require('p-limit').default;
const sendEmail = require('../services/emailService').sendEmail;
const responseEvents = require('../events/responseEvents');

const {
    Invitation,
    Survey,
    EmailList,
    EmailContact
} = require('../models');

const { generatePublicToken, hashToken } = require('../services/tokenService');

const { verifyAuthToken } = require('../utils/authMiddleware');
const { requireAdmin } = require('../utils/adminMiddleware');

/// CREATE and SEND
router.post('/:id/invitations/send', verifyAuthToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { list_id } = req.body;

        if (!list_id) {
            return res.status(400).json({ error: 'list_id is required' });
        }

        const survey = await Survey.findByPk(id);
        if (!survey) return res.status(404).json({ error: 'Survey not found' });

        const contacts = await EmailContact.findAll({
            where: { list_id },
            attributes: ['id', 'email', 'name']
        });

        const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            include: [{ model: EmailContact, as: 'contact', attributes: ['email'] }]
        });

        const existingEmailSet = new Set(existingInvites.map(inv => inv.contact.email));

        const limit = pLimit(5);
        const toInsert = [];
        let skipped = 0;
        let failed = 0;

        await Promise.all(
            contacts.map(c => limit(async () => {
                if (existingEmailSet.has(c.email)) {
                    skipped++;
                    return;
                }

                const rawToken = generatePublicToken();
                const tokenHash = hashToken(rawToken);
                const surveyLink = `http://localhost:5000/s/${survey.slug}?t=${rawToken}`;

                try {
                    await sendEmail({
                        to: c.email,
                        subject: `You're invited to: ${survey.title}`,
                        html: `
                            <p>Hi ${c.name || ''},</p>
                            <p>You are invited to take the survey:</p>
                            <p><strong>${survey.title}</strong></p>
                            <a href="${surveyLink}">Take Survey</a>

                            <!-- Tracking pixel -->
                            <img src="https://survey-app-trusca-daria.onrender.com/t/open/${rawToken}.png"
                                width="1" height="1"
                                style="display:block;"
                                alt="" />
                        `
                    });

                    toInsert.push({
                        survey_id: id,
                        contact_id: c.id,
                        token_hash: tokenHash,
                        sent_at: new Date()
                    });

                } catch (err) {
                    console.error(`Failed to send email to ${c.email}:`, err);
                    failed++;
                }
            }))
        );

        if (toInsert.length > 0) {
            await Invitation.bulkCreate(toInsert, { ignoreDuplicates: true });
            responseEvents.emit('invitation_created', {
                type: 'invitation_created',
                surveyId: id,
                inserted: toInsert.length
            });
        }

        res.status(201).json({
            inserted: toInsert.length,
            skipped,
            failed
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to send invitations' });
    }
});

/// GET by survey_id
router.get('/:id/invitations', verifyAuthToken, requireAdmin, async (req, res) => {
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
router.get('/:id/invitations/preview', verifyAuthToken, requireAdmin, async (req, res) => {
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