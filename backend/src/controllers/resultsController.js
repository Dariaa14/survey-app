const responseEvents = require('../events/responseEvents');
const { Response } = require('../models/response');
const { sequelize } = require('../db')

const surveyClients = new Map(); 

async function createResponse(req, res) {
  const { surveyId } = req.params;
  const { invitation_id, answers } = req.body;

  try {
    let createdResponse;

    await sequelize.transaction(async (t) => {
      createdResponse = await Response.create(
        {
          survey_id: surveyId,
          invitation_id,
          submitted_at: new Date(),
        },
        { transaction: t }
      );

      for (const answer of answers) {
        const { question_id, type } = answer;

        // 🔹 CHOICE
        if (type === 'choice' && Array.isArray(answer.option_ids)) {
          const rows = answer.option_ids.map((option_id) => ({
            id: sequelize.literal('gen_random_uuid()'),
            response_id: createdResponse.id,
            question_id,
            option_id,
          }));

          await sequelize.getQueryInterface().bulkInsert(
            'answers_choice',
            rows,
            { transaction: t }
          );
        }

        if (type === 'text' && answer.text) {
          await sequelize.getQueryInterface().bulkInsert(
            'answers_text',
            [
              {
                id: sequelize.literal('gen_random_uuid()'),
                response_id: createdResponse.id,
                question_id,
                text_value: answer.text,
              },
            ],
            { transaction: t }
          );
        }
      }
    });

    responseEvents.emit('response_created', {
      type: 'response_created',
      surveyId,
      responseId: createdResponse.id,
    });

    res.json({ success: true });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create response' });
  }
}

function streamResults(req, res) {
  const { id: surveyId } = req.params;

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  res.flushHeaders();

  if (!surveyClients.has(surveyId)) {
    surveyClients.set(surveyId, new Set());
  }

  surveyClients.get(surveyId).add(res);

  const handler = (data) => {
    if (data.surveyId === surveyId) {
      res.write(`data: ${JSON.stringify(data)}\n\n`);
    }
  };

  responseEvents.on('response_created', handler);

  req.on('close', () => {
    responseEvents.off('response_created', handler);

    const clients = surveyClients.get(surveyId);
    if (clients) {
      clients.delete(res);
      if (clients.size === 0) {
        surveyClients.delete(surveyId);
      }
    }
  });
}



module.exports = {
  streamResults,
  createResponse,
};