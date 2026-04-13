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

        console.log("🚀 START send invitations");
        console.log("📦 surveyId:", id);
        console.log("📨 list_id:", list_id);

        if (!list_id) {
            console.log("❌ Missing list_id");
            return res.status(400).json({ error: 'list_id is required' });
        }

        const survey = await Survey.findByPk(id);
        if (!survey) {
            console.log("❌ Survey not found");
            return res.status(404).json({ error: 'Survey not found' });
        }

        console.log("✅ Survey found:", survey.title);

        const contacts = await EmailContact.findAll({
            where: { list_id },
            attributes: ['id', 'email', 'name']
        });

        console.log(`👥 Contacts loaded: ${contacts.length}`);

        const existingInvites = await Invitation.findAll({
            where: { survey_id: id },
            include: [{ model: EmailContact, as: 'contact', attributes: ['email'] }]
        });

        console.log(`📬 Existing invites: ${existingInvites.length}`);

        const existingEmailSet = new Set(
            existingInvites.map(inv => inv.contact?.email).filter(Boolean)
        );

        const limit = pLimit(5);
        const toInsert = [];
        let skipped = 0;
        let failed = 0;

        console.log("⚙️ Starting email sending loop...");

        await Promise.all(
            contacts.map(c => limit(async () => {
                console.log(`➡️ Processing: ${c.email}`);

                if (existingEmailSet.has(c.email)) {
                    skipped++;
                    console.log(`⏭️ Skipped (already invited): ${c.email}`);
                    return;
                }

                const rawToken = generatePublicToken();
                const tokenHash = hashToken(rawToken);

                const surveyLink = `http://localhost:5000/s/${survey.slug}?t=${rawToken}`;

                console.log(`📧 Sending email to: ${c.email}`);

                try {
                    await sendEmail({
                        to: c.email,
                        subject: `You're invited to: ${survey.title}`,
                        html: `
                            <p>Hi ${c.name || ''},</p>
                            <p>You are invited to take the survey:</p>
                            <p><strong>${survey.title}</strong></p>
                            <a href="${surveyLink}">Take Survey</a>

                            <img src="https://survey-app-trusca-daria.onrender.com/t/open/${rawToken}.png"
                                width="1" height="1"
                                style="display:block;"
                                alt="" />
                        `
                    });

                    console.log(`✅ Email sent: ${c.email}`);

                    toInsert.push({
                        survey_id: id,
                        contact_id: c.id,
                        token_hash: tokenHash,
                        sent_at: new Date()
                    });

                } catch (err) {
                    console.error(`❌ Failed email: ${c.email}`);
                    console.error(err);
                    failed++;
                }
            }))
        );

        console.log("📊 Email loop finished");
        console.log("📥 To insert:", toInsert.length);
        console.log("⏭️ Skipped:", skipped);
        console.log("❌ Failed:", failed);

        if (toInsert.length > 0) {
            console.log("💾 Inserting invitations...");

            await Invitation.bulkCreate(toInsert, { ignoreDuplicates: true });

            console.log("✅ Invitations inserted");

            responseEvents.emit('invitation_created', {
                type: 'invitation_created',
                surveyId: id,
                inserted: toInsert.length
            });
        }

        console.log("🎉 DONE");

        res.status(201).json({
            inserted: toInsert.length,
            skipped,
            failed
        });

    } catch (err) {
        console.error("🔥 GLOBAL ERROR in send invitations:");
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