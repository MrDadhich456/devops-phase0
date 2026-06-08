# Phase 0 — Linux, Bash, Git & Python

> **Goal:** Build strong foundations before touching any DevOps tool.
> Duration: Week 1 · Days 1–5 · ~5 hrs/day

---

## What's Inside

### `bash/system_monitor.sh` — System Health Monitor
Monitors CPU, memory, and disk usage with automated alerting and timestamped logging.

**Features:**
- Checks disk usage — prints `WARNING` if > 80%
- Lists top 3 CPU-consuming processes
- Checks available memory — prints `WARNING` if < 200MB
- Loops 3 times with 5-second intervals
- Appends all output to `monitor.log` with timestamps

```bash
chmod +x bash/system_monitor.sh
./bash/system_monitor.sh
```

---

### `bash/backup_manager.sh` — Automated Backup Tool
Creates timestamped `.tar.gz` archives with automatic cleanup.

**Features:**
- Creates timestamped backups of a target directory
- Auto-prunes backups older than 2 minutes to manage disk space
- Logs backup creation and deletion events

```bash
chmod +x bash/backup_manager.sh
./bash/backup_manager.sh
```

---

### `python/fetcher.py` — CLI API Data Fetcher
A resilient Python CLI tool for fetching, filtering, and saving API data.

**Features:**
- Fetches posts from a public REST API using `requests`
- Filter results by `--user-id` via `argparse`
- Full error handling: `ConnectionError`, `Timeout`, invalid inputs
- Structured logging: INFO / WARNING / ERROR levels
- Saves filtered results to `posts.json`
- Prints summary: total fetched, filtered count, file size

```bash
cd python
pip install -r requirements.txt
python fetcher.py --user-id 3
```

---

## Key Commands Practised

```bash
# File permissions
chmod 755 file.sh
chmod 400 key.pem

# Process management
ps aux --sort=-%cpu | head -5
lsof -i :8080

# Disk inspection
df -h
du -sh /home/*

# File search
find /tmp -name "*.log" -mtime -1

# Text processing
grep -i "error" file.log | wc -l
awk 'NR==2 {print $5}'

# SSH
ssh-keygen -t rsa -b 4096
ssh -i key.pem user@ip

# Git workflow
git checkout -b feature/name
git rebase main
git merge --no-ff feature/name
git revert HEAD
git log --oneline --graph --all
```

---

## What I Learned

- Linux file permissions (`chmod`) and what 755/644 means in practice
- Process management — finding what's using a port, sorting by CPU
- Bash scripting patterns: functions, loops, conditionals, `awk` for text parsing
- Python error handling with `requests` — graceful failures vs crashes
- `argparse` for CLI tools — making scripts reusable with flags
- Python `logging` module — INFO / WARNING / ERROR structured output
- Git workflow: feature branches, rebasing, `--no-ff` merges, `git revert` vs `git reset`

---

## Pass Criteria

- [x] `system_monitor.sh` runs, loops 3 times, writes to `monitor.log`
- [x] `backup_manager.sh` creates and auto-prunes archives
- [x] `fetcher.py` works with `--user-id` flag, handles errors gracefully
- [x] All code pushed to GitHub via feature branch → PR → merge to main