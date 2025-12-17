import nodemailer from "nodemailer";
import fs from "fs";

// Path to your log/output file (optional)
const logFile = "resource_usage.log";

const emailBody = fs.existsSync(logFile)
  ? fs.readFileSync(logFile, "utf-8")
  : "AWS usage report completed successfully.";

function generateHtmlBody(textBody) {
  const lines = textBody.split('\n');
  let html = '<html><head><style>body { font-family: Arial, sans-serif; } pre { background-color: #f4f4f4; padding: 10px; border-radius: 5px; white-space: pre-wrap; } h2 { color: #333; }</style></head><body>';
  let currentSection = '';
  let sectionContent = [];

  const getSectionTitle = (command) => {
    if (command.includes('s3 ls')) return 'S3 Buckets';
    if (command.includes('describe-instances')) return 'EC2 Instances';
    if (command.includes('list-functions')) return 'Lambda Functions';
    if (command.includes('list-users')) return 'IAM Users';
    return '';
  };

  for (const line of lines) {
    if (line.startsWith('+ aws ')) {
      if (currentSection) {
        html += `<h2>${currentSection}</h2><pre>${sectionContent.join('\n')}</pre>`;
      }
      const command = line.slice(2); // remove '+ '
      currentSection = getSectionTitle(command);
      sectionContent = [];
    } else if (currentSection) {
      sectionContent.push(line);
    }
  }
  if (currentSection) {
    html += `<h2>${currentSection}</h2><pre>${sectionContent.join('\n')}</pre>`;
  }
  html += '</body></html>';
  return html;
}

const htmlBody = generateHtmlBody(emailBody);

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
      html: htmlBody,
    });

    console.log("Email sent successfully!");
  } catch (error) {
    console.error("Failed to send email:", error);
    process.exit(1);
  }
}

sendEmail();

