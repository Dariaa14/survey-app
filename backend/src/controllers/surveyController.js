const { sequelize } = require('../db');

function getSurveyStatsAttributes() {
    return [
        [
            sequelize.literal(`(
                SELECT COUNT(*) FROM invitations i
                WHERE i.survey_id = "Survey".id
            )`),
            'invitation_count'
        ],
        [
            sequelize.literal(`(
                SELECT COUNT(*) FROM invitations i
                WHERE i.survey_id = "Survey".id
                AND i.submitted_at IS NOT NULL
            )`),
            'submitted_count'
        ],
    ];
}

module.exports = {
    getSurveyStatsAttributes
};