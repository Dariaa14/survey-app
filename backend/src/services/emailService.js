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
    console.log("📤 [sendEmail] START");
    console.log("➡️ To:", to);
    console.log("➡️ Subject:", subject);

    try {
        const result = await transporter.sendMail({
            from: process.env.EMAIL_USER,
            to,
            subject,
            text,
            html,
            headers: {
                'X-SES-CONFIGURATION-SET': 'survey-app-config-set'
            }
        });

        console.log("📥 [sendEmail] SUCCESS");
        console.log("✉️ Message ID:", result?.messageId || result?.response);

        return result;

    } catch (err) {
        console.error("❌ [sendEmail] ERROR");
        console.error("➡️ To:", to);
        console.error("➡️ Subject:", subject);

        // full error dump
        console.error("📛 Error name:", err.name);
        console.error("📛 Error message:", err.message);
        console.error("📛 Full error:", err);

        throw err;
    }
}

module.exports = {
    sendEmail
};