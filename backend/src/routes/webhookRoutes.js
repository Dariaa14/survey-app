const express = require('express');
const router = express.Router();

const { Invitation, EmailContact } = require('../models');
const {Op} = require('sequelize');

router.post('/ses', async (req, res) => {
    try {
        const event = req.body; 
        console.log('SES webhook received:', event);

        if (event.notificationType === 'Bounce') {
            const bouncedEmails = event.bounce.bouncedRecipients.map(r => r.emailAddress);

            for (const email of bouncedEmails) {
                const invite = await Invitation.findOne({
                    include: [{
                        model: EmailContact,
                        as: 'contact',
                        where: { email }
                    }]
                });
                if (invite) {
                    invite.bounced_at = new Date();
                    invite.status = 'bounced';
                    await invite.save();
                }
            }
        }

        res.status(200).send('OK');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error');
    }
});

module.exports = router;