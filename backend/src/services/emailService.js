const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    host: 'email-smtp.eu-north-1.amazonaws.com',
    port: 465,
    secure: true,
    auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,  
    }
});

async function sendEmail({ to, subject, text, html }) {
    try {
        const info = await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to,
            subject,
            text,
            html,
            headers: {
                'X-SES-CONFIGURATION-SET': 'survey-app-config-set'
            }
        });

        return info;
    } catch (err) {
        console.error('Error sending email:', err);
        throw err;
    }
}

module.exports = {
    sendEmail
};