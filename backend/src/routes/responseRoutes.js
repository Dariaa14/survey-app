const express = require('express');
const router = express.Router();
const { sequelize } = require('../db')

const { Response, AnswerChoice, AnswerText } = require('../models');
const { validateToken } = require('../utils/tokenValidation');

/// CREATE
router.post(
  '/:slug/responses',
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

module.exports = router;