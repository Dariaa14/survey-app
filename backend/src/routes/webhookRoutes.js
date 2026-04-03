const express = require('express');
const router = express.Router();

const { Invitation, EmailContact } = require('../models');
const {Op} = require('sequelize');

router.post('/ses', async (req, res) => {
    try {
        const message = JSON.parse(req.body.Message);

        if (message.Type === 'SubscriptionConfirmation') {
            console.log('Confirming SNS subscription...');
            await fetch(message.SubscribeURL);
        }

        if (message.notificationType === 'Bounce') {
            const bouncedEmails = message.bounce.bouncedRecipients.map(r => r.emailAddress);

            const invitations = await Invitation.findAll({
                include: [
                    {
                        model: EmailContact,
                        as: 'contact',
                        where: {
                            email: {
                                [Op.in]: bouncedEmails
                            }
                        }
                    }
                ]
            });

            await Promise.all(invitations.map(async (invitation) => {
                await invitation.update({ bounced_at: new Date() });
            }));

        }

        res.sendStatus(200);

    } catch (err) {
        console.error(err);
        res.sendStatus(500);
    }
});

module.exports = router;