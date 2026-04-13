const { SESClient, SendEmailCommand } = require("@aws-sdk/client-ses");


const ses = new SESClient({
  region: "eu-north-1",
  credentials: {
    accessKeyId: process.env.SMTP_USER,
    secretAccessKey: process.env.SMTP_PASS,
  },
});


async function sendEmail({ to, subject, text, html }) {
  try {
    const command = new SendEmailCommand({
      Source: process.env.EMAIL_USER,
      Destination: {
        ToAddresses: [to],
      },
      Message: {
        Subject: {
          Data: subject,
          Charset: "UTF-8",
        },
        Body: {
          Text: text ? { Data: text, Charset: "UTF-8" } : undefined,
          Html: html ? { Data: html, Charset: "UTF-8" } : undefined,
        },
      },
      ConfigurationSetName: "survey-app-config-set",
    });

    const result = await ses.send(command);

    return result;
  } catch (err) {
    console.error("❌ SES ERROR:", err);
    throw err;
  }
}

module.exports = {
    sendEmail
};