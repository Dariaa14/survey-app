const express = require('express');
const router = express.Router();

const { Invitation } = require('../models');
const { hashToken } = require('../services/tokenService');

const pixel = Buffer.from(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=',
    'base64'
);

router.get('/open/:token.png', async (req, res) => {
    try {
        const tokenHash = hashToken(req.params.token);

        await Invitation.update(
            { email_opened_at: new Date() },
            {
                where: {
                    token_hash: tokenHash,
                    email_opened_at: null
                }
            }
        );

    } catch (err) {
        console.error(err);
    }

    res.set({
        'Content-Type': 'image/png',
        'Cache-Control': 'no-store'
    });

    res.send(pixel);
});

module.exports = router;