const { Survey } = require('./survey');
const { Question } = require('./question');
const { Option } = require('./option');
const { EmailList } = require('./emailList');
const { EmailContact } = require('./emailContact');
const { Invitation } = require('./invitation');
const { Response } = require('./response');
const { AnswerChoice } = require('./answerschoice');
const { AnswerText } = require('./answerstext');


Survey.hasMany(Question, { foreignKey: 'survey_id', as: 'questions' });
Question.belongsTo(Survey, { foreignKey: 'survey_id', as: 'survey' });


Question.hasMany(Option, { foreignKey: 'question_id', as: 'options' });
Option.belongsTo(Question, { foreignKey: 'question_id', as: 'question' });

Survey.hasMany(Invitation, { foreignKey: 'survey_id', as: 'invitations' });
Invitation.belongsTo(Survey, { foreignKey: 'survey_id', as: 'survey' });


EmailList.hasMany(EmailContact, { foreignKey: 'list_id', as: 'contacts' });
EmailContact.belongsTo(EmailList, { foreignKey: 'list_id', as: 'list' });


EmailContact.hasMany(Invitation, { foreignKey: 'contact_id', as: 'invitations' });
Invitation.belongsTo(EmailContact, { foreignKey: 'contact_id', as: 'contact' });

Survey.hasMany(Response, { foreignKey: 'survey_id', as: 'responses' });
Response.belongsTo(Survey, { foreignKey: 'survey_id', as: 'survey' });

Invitation.hasOne(Response, { foreignKey: 'invitation_id', as: 'response' });
Response.belongsTo(Invitation, { foreignKey: 'invitation_id', as: 'invitation' });

Response.hasMany(AnswerChoice, { foreignKey: 'response_id', as: 'answerChoices' });
AnswerChoice.belongsTo(Response, { foreignKey: 'response_id', as: 'response' });

Response.hasMany(AnswerText, { foreignKey: 'response_id', as: 'answerTexts' });
AnswerText.belongsTo(Response, { foreignKey: 'response_id', as: 'response' });


Question.hasMany(AnswerChoice, { foreignKey: 'question_id', as: 'answerChoices' });
AnswerChoice.belongsTo(Question, { foreignKey: 'question_id', as: 'question' });

Question.hasMany(AnswerText, { foreignKey: 'question_id', as: 'answerTexts' });
AnswerText.belongsTo(Question, { foreignKey: 'question_id', as: 'question' });

module.exports = {
    Survey,
    Question,
    Option,
    EmailList,
    EmailContact,
    Invitation,
    Response,
    AnswerChoice,
    AnswerText,
};