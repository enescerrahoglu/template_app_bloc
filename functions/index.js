const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();


exports.sendMail = functions.https.onCall((data) => {
    const { to, subject, text, html } = data;

    if (!to || !subject) {
        throw new functions.https.HttpsError("invalid-argument", "Missing required parameters.");
    }

    const mailRef = admin.firestore().collection("mail");

    if (text || html) {
        mailRef.add({
            to,
            message: {
                subject,
                text,
                html,
            },
        });
    }

    return { success: true };
});

exports.sendVerificationCode = functions.https.onCall((data) => {
    const { to, subject, text } = data;

    if (!to || !subject || !text) {
        throw new functions.https.HttpsError("invalid-argument", "Missing required parameters.");
    }

    const verificationCode = Math.floor(Math.random() * 9000) + 1000;

    const mailRef = admin.firestore().collection("mail");

    mailRef.add({
        to,
        message: {
            subject,
            text: `${text} ${verificationCode}`,
        },
    });

    return { success: true, verificationCode };
});