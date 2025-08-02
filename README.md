# Docker Containers & Website Health Monitoring Suite

## Project Overview
<img width="903" height="423" alt="image (36)" src="https://github.com/user-attachments/assets/ae446069-a70c-4940-8925-1f8b9641b772" />

This project is a complete monitoring suite designed to help you track the health of your Docker containers and the uptime of external websites. It integrates alerting, log rotation, and JSON dashboard generation - all using pure shell scripting.

## Features

- **Docker Container Health Check**
  - Inspects running Docker containers.
  - Logs container names, health status, and timestamps.
<img width="1007" height="555" alt="image (37)" src="https://github.com/user-attachments/assets/10234ad9-06b1-41a5-bf5a-f4bf72ba535a" />


- **Website Uptime Monitoring**
  - Checks website availability via HTTP status codes.
  - Color-coded terminal output for quick status identification.
  - Logs each check with timestamps.
<img width="697" height="931" alt="image (34)" src="https://github.com/user-attachments/assets/31b29b95-fe15-47be-8d53-152879de4e96" />


- **Alert System**
  - Sends alerts when websites go down.
  - Uses local flag files to avoid spamming alerts.
  <img width="1747" height="958" alt="image (38)" src="https://github.com/user-attachments/assets/c8c8383e-174f-4f08-9936-7fc2fb1bd1f4" />



- **Log Rotation**
  - Automatically rotates log files when they exceed a size threshold.
  - Archives logs with timestamped filenames.

- **JSON-Based Dashboard**
  - Generates and updates a JSON file summarizing website checks.
  - Includes service name, status, HTTP code, latency, and last checked time.

- **Cron Integration**
  - Supports scheduled checks via cron (e.g., every 5 minutes).

## Folder Structure

```
project-root/
├── config/
│   └── services.txt
├── logs/
│   ├── website-health.log
│   ├── json_logs/
│   │   └── logs.json
│   └── archived logs
├── scripts/
│   ├── website_checker.sh
│   ├── docker_health.sh
│   ├── alert.sh
│   ├── rotate_logs.sh
│   └── update_dashboard.sh
└── README.md
```

## How It Works

1. **Website & Docker Checks**: The system loops through configured websites and running Docker containers, checking their health and logging results.
2. **Alerts**: Sends one-time alerts when a site goes down, using flag files to avoid duplicates.
3. **Log Management**: Rotates and archives logs automatically when they grow too large.
4. **Dashboard**: Updates a JSON file with the latest service statuses to act as a lightweight dashboard source.
5. **Automation**: Easily integrates with cron for continuous, automated monitoring.

## Setup Instructions

1. Clone the repository.
2. Add website URLs to `config/services.txt` in the format:

```
website="example.com"
website="another-example.com"
```

3. Configure your Slack or email webhook in `alert.sh`.
4. Set up a cron job to run `website_checker.sh` at your desired interval.

Example crontab entry (every 5 minutes):

```
*/5 * * * * /path/to/project/scripts/website_checker.sh
```

## Requirements

- Bash
- curl
- jq (for JSON validation, optional)

## Author

Daksh Sawhney
---
