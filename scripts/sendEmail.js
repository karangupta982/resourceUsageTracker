import nodemailer from "nodemailer";
import fs from "fs";

// Path to your log/output file (optional)
const logFile = "resource_usage.log";

const emailBody = fs.existsSync(logFile)
  ? fs.readFileSync(logFile, "utf-8")
  : "AWS usage report completed successfully.";

async function sendEmail() {
  try {
    // Create reusable transporter using Gmail SMTP
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL_USER, // from GitHub Secrets
        pass: process.env.EMAIL_PASS, // Gmail App Password
      },
    });

    // Send mail
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: process.env.RECEIVERS_EMAIL,
      subject: "Daily AWS Usage Report",
      text: emailBody,
    });

    console.log("Email sent successfully!");
  } catch (error) {
    console.error("Failed to send email:", error);
    process.exit(1);
  }
}

sendEmail();

