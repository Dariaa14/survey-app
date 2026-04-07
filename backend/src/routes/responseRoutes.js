const express = require('express');
const router = express.Router();
const { sequelize } = require('../db')

const { Response, AnswerChoice, AnswerText } = require('../models');
const { validateToken } = require('../utils/tokenValidation');

const { Parser } = require('json2csv');

/// CREATE
router.post(
  '/public/surveys/:slug/responses',
  validateToken,
  async (req, res) => {
    const transaction = await sequelize.transaction();

    try {
      const { answers = [] } = req.body;

      const invitation = req.invitation;

      if (invitation.submitted_at) {
        await transaction.rollback();
        return res.status(409).json({ error: 'ALREADY_SUBMITTED' });
      }

      const response = await Response.create(
        {
          survey_id: invitation.survey_id,
          invitation_id: invitation.id,
          submitted_at: new Date(),
        },
        { transaction }
      );

      const choiceRows = [];
      const textRows = [];

      for (const a of answers) {
        const questionId = a.question_id || a.questionId;
        if (!questionId) {
          continue;
        }

        const optionIds = Array.isArray(a.option_ids)
          ? a.option_ids
          : a.option_id
            ? [a.option_id]
            : [];

        const textValue = (a.text_value || a.textValue || '').trim();

        const validOptionIds = optionIds.filter((id) =>
          typeof id === 'string' && id.trim().length > 0,
        );

        for (const optionId of validOptionIds) {
          choiceRows.push({
            response_id: response.id,
            question_id: questionId,
            option_id: optionId,
          });
        }

        if (textValue.length > 0) {
          textRows.push({
            response_id: response.id,
            question_id: questionId,
            text_value: textValue,
          });
        }
      }

      if (choiceRows.length > 0) {
        await AnswerChoice.bulkCreate(choiceRows, { transaction });
      }

      if (textRows.length > 0) {
        await AnswerText.bulkCreate(textRows, { transaction });
      }

      await invitation.update(
        {
          submitted_at: new Date(),
        },
        { transaction }
      );

      await transaction.commit();

      res.status(201).json({
        message: 'Response submitted successfully',
      });

    } catch (err) {
      await transaction.rollback();
      console.error(err);
      res.status(500).json({ error: 'Failed to submit response' });
    }
  }
);

/// Summary
router.get('/surveys/:id/results/summary', async (req, res) => {
  try {
    const { id } = req.params;

    const results = await sequelize.query(
      `
      SELECT
        COUNT(*) AS invited,
        COUNT(sent_at) AS sent,
        COUNT(email_opened_at) AS email_opened,
        COUNT(survey_opened_at) AS survey_opened,
        COUNT(submitted_at) AS submitted,
        COUNT(bounced_at) AS bounced
      FROM invitations
      WHERE survey_id = :surveyId
      `,
      {
        replacements: { surveyId: id },
        type: sequelize.QueryTypes.SELECT,
      }
    );

    res.json(results[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch summary' });
  }
});

/// Statistics of question
router.get('/surveys/:id/results/questions', async (req, res) => {
  try {
    const { id } = req.params;

    const results = await sequelize.query(
      `
      SELECT
        q.id AS question_id,
        q.title AS question_text,
        o.id AS option_id,
        o.label AS option_text,
        COUNT(ac.id) AS count,
        ROUND(
          COUNT(ac.id) * 100.0 /
          NULLIF(SUM(COUNT(ac.id)) OVER (PARTITION BY q.id), 0),
          2
        ) AS percentage
      FROM questions q
      LEFT JOIN options o ON o.question_id = q.id
      LEFT JOIN answers_choice ac
        ON ac.option_id = o.id
      WHERE q.survey_id = :surveyId
      GROUP BY q.id, o.id
      ORDER BY q."order", o."order"
      `,
      {
        replacements: { surveyId: id },
        type: sequelize.QueryTypes.SELECT,
      }
    );

    res.json(results);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch question stats' });
  }
});

/// Comments 
router.get('/surveys/:id/results/comments', async (req, res) => {
  try {
    const { id } = req.params;
    const { q = '', page = 1, question_id } = req.query;

    const limit = 10;
    const offset = (page - 1) * limit;

    const results = await sequelize.query(
      `
      SELECT
        at.id,
        at.text_value,
        at.question_id,
        at.response_id,
        r.submitted_at
      FROM answers_text at
      JOIN responses r ON r.id = at.response_id
      WHERE r.survey_id = :surveyId
        ${question_id ? 'AND at.question_id = :questionId' : ''}
        AND at.text_value ILIKE :search
      ORDER BY r.submitted_at DESC
      LIMIT :limit OFFSET :offset
      `,
      {
        replacements: {
          surveyId: id,
          questionId: question_id,
          search: `%${q}%`,
          limit,
          offset,
        },
        type: sequelize.QueryTypes.SELECT,
      }
    );

    res.json(results);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch comments' });
  }
});

/// Export CSV
router.get('/surveys/:id/results/export.csv', async (req, res) => {
  try {
    const { id } = req.params;

    const results = await sequelize.query(
      `
      SELECT
        r.id AS response_id,
        r.submitted_at,
        q.title AS question,
        o.label AS selected_option,
        at.text_value
      FROM responses r
      LEFT JOIN answers_choice ac ON ac.response_id = r.id
      LEFT JOIN options o ON o.id = ac.option_id
      LEFT JOIN questions q ON q.id = ac.question_id
      LEFT JOIN answers_text at
        ON at.response_id = r.id AND at.question_id = q.id
      WHERE r.survey_id = :surveyId
      ORDER BY r.submitted_at
      `,
      {
        replacements: { surveyId: id },
        type: sequelize.QueryTypes.SELECT,
      }
    );

    const parser = new Parser();
    const csv = parser.parse(results);

    res.header('Content-Type', 'text/csv');
    res.attachment('survey_results.csv');
    res.send(csv);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to export CSV' });
  }
});

module.exports = router;