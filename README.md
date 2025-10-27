# Log Monitoring & Processing Automation Script

## Overview
This project includes a Bash script designed to automate daily server monitoring and log processing, created as part of a Data Engineering learning module.

The script performs:
- Disk usage monitoring
- Top processes inspection
- Network connectivity check
- Log file categorization and processing
- Daily reporting

---

## Features

| Feature | Description |
|--------|-------------|
| Disk Monitoring | Checks if disk usage exceeds 80% and generates a warning |
| Process Monitoring | Displays the top 5 processes by memory usage |
| Network Check | Determines whether the server connection is online |
| Log Categorization | Identifies Error, Access, and General log files |
| Log Archiving | Renames log files with timestamps and moves them to a processed directory |
| Cleanup Process | Deletes processed logs older than 7 days |
| Logging and Reporting | Stores all results in a daily report file |

---

## Project Structure

```bash
project_pipeline/
│
├── logs/
│   ├── raw/          # Incoming log files before processing
│   └── processed/    # Logs after being renamed and moved
│
└── reports/          # Daily generated reports
