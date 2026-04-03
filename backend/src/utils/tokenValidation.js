const { Invitation, Survey } = require('../models');
const { hashToken } = require('../services/tokenService');

async function _validateToken(slug, rawToken) {
    if (!rawToken) return { valid: false, reason: 'MISSING' };

    const hash = hashToken(rawToken);

    const invitation = await Invitation.findOne({
        where: { token_hash: hash },
        include: {
            model: Survey,
            as: 'survey',
            where: { slug },
        },
    });

    if (!invitation) return { valid: false, reason: 'INVALID' };
    if (invitation.survey.status === 'closed') return { valid: false, reason: 'CLOSED' };
    if (invitation.submitted_at) return { valid: false, reason: 'ALREADY_SUBMITTED' };

    return { valid: true, invitation };
}

async function validateToken(req, res, next) {
    try {
        const { slug } = req.params;
        const token = req.query.t; 

        const result = await _validateToken(slug, token);

        if (!result.valid) {
            return res.status(400).json({ error: result.reason });
        }

        req.invitation = result.invitation; 
        next();
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Token validation failed' });
    }
}

module.exports = { validateToken };