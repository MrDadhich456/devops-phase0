# DevOps Phase 0: Core Foundations

This repository contains foundational DevOps scripts focusing on system monitoring, automation, and API interaction.

## 📁 Repository Structure

* `/bash`: Contains Linux automation scripts.
* `/python`: Contains CLI tools and API fetchers.

## 🛠️ Tools Included

### 1. System Monitor (`bash/system_monitor.sh`)
Monitors CPU, Memory, and Disk usage, logging warnings if thresholds are exceeded.
* **Usage:** `./system_monitor.sh`
* **Output:** Appends to `monitor.log` (ignored by git).

### 2. Backup Manager (`bash/backup_manager.sh`)
Creates timestamped `.tar.gz` backups of a target directory and automatically prunes backups older than 2 minutes to save disk space.
* **Usage:** `./backup_manager.sh`

### 3. API Fetcher (`python/fetcher.py`)
A resilient Python CLI tool that fetches user data from a mock API, filters it, and saves it locally. Includes advanced error handling.
* **Requirements:** `pip install -r python/requirements.txt`
* **Usage:** `python python/fetcher.py --user-id 3`


## What I learned building this
- How Linux file permissions (chmod) and process management actually work
- Bash scripting patterns: functions, loops, conditionals, awk for text parsing
- Python error handling with requests — graceful failures vs crashes
- Clean Git workflow: feature branches, rebasing, PRs, no direct pushes to main





[![Automate Python Tests](https://github.com/MrDadhich456/devops-phase0/actions/workflows/python-tests.yml/badge.svg)](https://github.com/MrDadhich456/devops-phase0/actions/workflows/python-tests.yml)