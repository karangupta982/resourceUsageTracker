# AWS Resource Usage Tracker

This project automatically tracks your daily AWS resource usage (including EC2, S3, Lambda, and IAM) and sends a daily email report using GitHub Actions, Node.js, and Nodemailer.

---

## Features

- Automated daily execution through GitHub Actions cron jobs  
- Tracks AWS resources:
  - EC2 instances (IDs, states, public IPs)
  - S3 buckets
  - Lambda functions
  - IAM users
- Sends a daily email with the usage summary  
- Uses GitHub Secrets for secure credential storage  

---

## Project Structure

```

resourceUsageTracker/
├── resourceTracker.sh                 # Shell script to track AWS resources
├── scripts/
│   └── sendEmail.js                   # Sends daily usage report via email
├── .github/
│   └── workflows/
│       └── daily_usage.yaml           # GitHub Actions workflow for automation
├── package.json                       # Node.js configuration file
└── resource_usage.log                 # Log file generated after each run

````

---

## How It Works

1. The GitHub Actions workflow runs daily at 6 AM UTC (`.github/workflows/daily_usage.yaml`).
2. It configures AWS credentials using GitHub Secrets.
3. The `resourceTracker.sh` script collects AWS usage details.
4. The output is saved in `resource_usage.log`.
5. The Node.js script (`sendEmail.js`) emails the report to the recipient.

---

## Setup Instructions

### Step 1: Clone the Repository
```bash
git clone https://github.com/karangupta982/resourceUsageTracker.git
cd resourceUsageTracker
````

---

### Step 2: Add Required GitHub Secrets

In your GitHub repository:

* Go to **Settings → Secrets and variables → Actions → New repository secret**
* Add the following secrets:

| Secret Name             | Description                                   |
| ----------------------- | --------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key                           |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key                    |
| `AWS_REGION`            | Your default AWS region (e.g. `us-east-1`)    |
| `EMAIL_USER`            | Sender Gmail address                          |
| `EMAIL_PASS`            | Gmail App Password (not your actual password) |
| `RECEIVERS_EMAIL`       | Recipient email address for daily report      |

---

### Step 3: Enable Gmail App Passwords

If you are using Gmail:

1. Enable **2-Step Verification** on your Google account.
2. Go to **Google Account → Security → App passwords**.
3. Generate a new app password (for “Mail” → “Other” → “Nodemailer Script”).
4. Use this generated password as the `EMAIL_PASS` secret.

---

### Step 4: Workflow Configuration

The GitHub Actions workflow file `.github/workflows/daily_usage.yaml` runs on a daily schedule:

```yaml
on:
  schedule:
    - cron: "0 6 * * *" # Runs every day at 6 AM UTC
  workflow_dispatch: # Manual trigger support
```

You can modify the schedule as needed.
For custom cron expressions, visit [crontab.guru](https://crontab.guru/).

---

### Step 5: Run Locally (Optional)

To test the setup manually on your local machine:

**Make the script executable:**

```bash
chmod +x resourceTracker.sh
```

**Run the script:**

```bash
./resourceTracker.sh > resource_usage.log 2>&1
```

**Send the email manually:**

```bash
node scripts/sendEmail.js
```

---

## Example Email Output

```
Subject: Daily AWS Usage Report

----------------------------------------------------
S3 Buckets:
2025-10-05  bucket-one
2025-10-05  bucket-two

EC2 Instances:
i-0123abcd  running  13.235.45.120
i-0456efgh  stopped  -

Lambda Functions:
myLambdaFunction   nodejs18.x

IAM Users:
admin-user    AIDABCDEFG1234
----------------------------------------------------
```

---

## Tech Stack

* **Bash Script (AWS CLI)** — For data collection
* **GitHub Actions** — For workflow automation
* **Node.js + Nodemailer** — For sending email notifications
* **AWS CLI** — For interacting with AWS resources

---

## Future Improvements

* Attach the usage log as a `.txt` file in the email
* Generate formatted HTML email reports
* Add cost tracking and AWS billing summary
* Integrate with Slack or Discord for notifications
* Multi-account AWS reporting

