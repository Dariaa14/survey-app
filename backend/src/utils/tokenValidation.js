const { Invitation, Survey } = require('../models');
const { hashToken } = require('./token');

async function validateToken(slug, rawToken) {
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

module.exports = { validateToken };