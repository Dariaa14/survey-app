const express = require('express');
const router = express.Router();

const { EmailList, EmailContact } = require('../models');
const { verifyToken } = require('../utils/authMiddleware');
const { requireAdmin } = require('../utils/adminMiddleware');

/// CREATE
router.post('/', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { owner_id, name } = req.body;

        if (!owner_id || !name) {
            return res.status(400).json({ error: 'owner_id and name are required' });
        }

        const list = await EmailList.create({
            owner_id,
            name,
            created_at: new Date()
        });

        res.status(201).json(list);

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to create email list' });
    }
});

/// GET by id
router.get('/:id', verifyToken, requireAdmin, async (req, res) => {
    try {
        const list = await EmailList.findByPk(req.params.id, {
            include: [
                {
                    model: EmailContact,
                    as: 'contacts'
                }
            ],
            order: [
                [{ model: EmailContact, as: 'contacts' }, 'created_at', 'ASC']
            ]
        });

        if (!list) {
            return res.status(404).json({ error: 'Email list not found' });
        }

        res.json(list);

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch email list' });
    }
});

/// GET by owner_id
router.get('/user/:ownerId', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { ownerId } = req.params;

        const lists = await EmailList.findAll({
            where: { owner_id: ownerId },
            include: [
                {
                    model: EmailContact,
                    as: 'contacts'
                }
            ],
            order: [
                ['created_at', 'DESC'],
                [{ model: EmailContact, as: 'contacts' }, 'created_at', 'ASC']
            ]
        });

        res.json(lists);

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch email lists' });
    }
});

/// UPDATE
router.put('/:id', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { name } = req.body;

        const list = await EmailList.findByPk(req.params.id);
        if (!list) return res.status(404).json({ error: 'Email list not found' });

        await list.update({ name });
        res.json(list);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update email list' });
    }
});

/// DELETE
router.delete('/:id', verifyToken, requireAdmin, async (req, res) => {
    try {
        const list = await EmailList.findByPk(req.params.id);

        if (!list) {
            return res.status(404).json({ error: 'Email list not found' });
        }

        await list.destroy();

        res.json({ message: 'Email list deleted successfully' });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to delete email list' });
    }
});

/// CREATE contact
router.post('/:id/contacts', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { email, name } = req.body;
        if (!email) return res.status(400).json({ error: 'Email is required' });

        const list = await EmailList.findByPk(req.params.id);
        if (!list) return res.status(404).json({ error: 'Email list not found' });

        const contact = await EmailContact.create({
            list_id: list.id,
            email,
            name: name || null,
            created_at: new Date()
        });

        res.status(201).json(contact);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to add contact' });
    }
});

/// UPDATE contact
router.put('/:id/contacts/:contactId', verifyToken, requireAdmin, async (req, res) => {
    try {
        const { email, name } = req.body;

        const contact = await EmailContact.findOne({
            where: { id: req.params.contactId, list_id: req.params.id }
        });

        if (!contact) return res.status(404).json({ error: 'Contact not found' });

        await contact.update({ email, name });
        res.json(contact);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update contact' });
    }
});

/// DELETE contact
router.delete('/:id/contacts/:contactId', verifyToken, requireAdmin, async (req, res) => {
    try {
        const contact = await EmailContact.findOne({
            where: { id: req.params.contactId, list_id: req.params.id }
        });

        if (!contact) return res.status(404).json({ error: 'Contact not found' });

        await contact.destroy();
        res.json({ message: 'Contact deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to delete contact' });
    }
});

module.exports = router;