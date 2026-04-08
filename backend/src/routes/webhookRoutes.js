const express = require('express');
const router = express.Router();
const axios = require('axios');

const { Invitation, EmailContact } = require('../models');

router.post('/ses', express.text({type: '*/*'}), async (req, res) => {
    try {
        let snsMessage = req.body;

        if (typeof snsMessage === 'string') {
            try {
                snsMessage = JSON.parse(snsMessage);
            } catch (err) {
                console.error('Failed to parse SNS message:', err);
                return res.sendStatus(400);
            }
        }

        if (!snsMessage || !snsMessage.Type) {
            console.error('Empty or invalid SNS payload:', snsMessage);
            return res.sendStatus(400);
        }

        if (snsMessage.Type === 'SubscriptionConfirmation') {
            try {
                await axios.get(snsMessage.SubscribeURL);
            } catch (err) {
                console.error('Failed to confirm SNS subscription:', err);
            }
            return res.sendStatus(200); 
        }

        if (snsMessage.Type === 'Notification') {
            const event = JSON.parse(snsMessage.Message);

            if (event.eventType === 'Bounce') {
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
            return res.sendStatus(200);
        }
        return res.sendStatus(200);
        
    } catch (err) {
        console.error('Webhook error:', err);
        return res.sendStatus(500);
    }
});

module.exports = router;