# ☁️ cloud-ops — DevOps & Cloud Engineering Roadmap

> A complete, hands-on DevOps learning journey — from Linux fundamentals to a fully automated cloud-deployed pipeline.
> Built by **Aaryan Dadhich** | BTech CSE (IoT) @ MLVTEC, Bhilwara

[![CI Pipeline](https://github.com/MrDadhich456/cloud-ops/actions/workflows/python-tests.yml/badge.svg)](https://github.com/MrDadhich456/cloud-ops/actions/workflows/python-tests.yml)
![Phases Complete](https://img.shields.io/badge/Phases%20Complete-3%2F8-blue)
![Tools](https://img.shields.io/badge/Tools-Bash%20%7C%20Python%20%7C%20Docker%20%7C%20GitHub%20Actions%20%7C%20AWS-informational)

---

## 🗺️ Roadmap Progress

| Phase | Topic | Status | Key Tools |
|-------|-------|--------|-----------|
| Phase 0 | Linux, Bash, Git, Python | ✅ Complete | Bash, Python, Git, Linux |
| Phase 1 | Docker & Containerisation | ✅ Complete | Docker, docker-compose, Docker Hub |
| Phase 2 | CI/CD with GitHub Actions | ✅ Complete | GitHub Actions, pytest, flake8 |
| Phase 3 | AWS Fundamentals | 🔄 In Progress | AWS CLI, EC2, S3, IAM, VPC |
| Phase 4 | Infrastructure as Code | ⏳ Upcoming | Terraform, HCL |
| Phase 5 | Kubernetes | ⏳ Upcoming | minikube, kubectl, Helm |
| Phase 6 | Monitoring | ⏳ Upcoming | Prometheus, Grafana, Alertmanager |
| Phase 7 | Capstone Project | ⏳ Upcoming | All tools — full loop |

---

## 📁 Repository Structure

```
cloud-ops/
├── phase-0/                    # Linux, Bash scripting, Python CLI
│   ├── bash/
│   │   ├── system_monitor.sh   # CPU/memory/disk monitor with logging
│   │   └── backup_manager.sh   # Timestamped backup with auto-pruning
│   └── python/
│       ├── fetcher.py          # CLI API fetcher with argparse + logging
│       └── requirements.txt
│
├── phase-1/                    # Docker & Containerisation
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── README.md
│
├── phase-2/                    # CI/CD with GitHub Actions
│   ├── calculator.py
│   ├── test_calculator.py
│   ├── requirements.txt
│   └── README.md
│
├── phase-3/                    # AWS Fundamentals (In Progress)
│   └── README.md
│
├── .github/
│   └── workflows/
│       └── python-tests.yml    # CI pipeline: lint → test → build
│
└── README.md
```

---

## ✅ Phase 0 — Linux, Bash, Git & Python

**Goal:** Build strong foundations before touching any DevOps tool.

### What's inside

**`bash/system_monitor.sh`** — System health monitor
- Checks disk usage, CPU processes, and available memory
- Prints `WARNING` if disk > 80% or memory < 200MB
- Timestamps and appends every check to `monitor.log`
- Loops 3 times with 5-second intervals

```bash
chmod +x bash/system_monitor.sh
./bash/system_monitor.sh
```

**`bash/backup_manager.sh`** — Automated backup tool
- Creates timestamped `.tar.gz` archives of a target directory
- Auto-prunes backups older than 2 minutes to manage disk space

```bash
chmod +x bash/backup_manager.sh
./bash/backup_manager.sh
```

**`python/fetcher.py`** — CLI API data fetcher
- Fetches posts from a public API with `requests`
- Filter by `--user-id` argument via `argparse`
- Full error handling: `ConnectionError`, `Timeout`, invalid inputs
- Structured logging: INFO / WARNING / ERROR levels
- Saves filtered results to `posts.json`

```bash
cd python
pip install -r requirements.txt
python fetcher.py --user-id 3
```

### What I learned
- Linux file permissions (`chmod`), process management (`ps`, `lsof`), and disk inspection (`df`, `du`)
- Bash scripting: functions, loops, conditionals, `awk` for text parsing
- Python error handling with `requests` — graceful failures vs crashes
- `argparse` for CLI tools + Python `logging` module patterns
- Git workflow: feature branches, rebasing, `--no-ff` merges, `git revert` vs `git reset`

---

## ✅ Phase 1 — Docker & Containerisation

**Goal:** Package any application to run consistently anywhere.

### What's inside

- `Dockerfile` — Production-ready image using `python:3.11-slim`
- Layer caching optimisation — deps installed before code copy
- `docker-compose.yml` — Multi-container setup (app + Postgres)
- Volume persistence — data survives container restarts
- Docker Hub push — image available publicly

```bash
# Build and run
docker build -t cloud-ops:v1 .
docker run cloud-ops:v1

# Multi-container
docker-compose up
docker-compose down -v
```

### What I learned
- Container vs VM — why containers are faster and lighter
- Dockerfile layer caching — why `COPY requirements.txt` comes before `COPY . .`
- `ENTRYPOINT` vs `CMD` — fixed executable vs default arguments
- Docker bridge networking — containers finding each other by name, not IP
- Named volumes vs bind mounts — when to use each

---

## ✅ Phase 2 — CI/CD with GitHub Actions

**Goal:** Every code push automatically lints, tests, builds, and ships.

### Pipeline

```
git push → flake8 lint → pytest (Python 3.10 + 3.11 matrix) → Docker build + push to Docker Hub
```

### What's inside

- `calculator.py` — Python app with `add()`, `subtract()`, `multiply()`
- `test_calculator.py` — pytest test suite with edge cases
- `.github/workflows/python-tests.yml` — Full CI/CD pipeline

**Pipeline jobs:**
1. **lint-and-test** — `flake8` code style check + `pytest` on Python 3.10 AND 3.11 simultaneously
2. **build-and-push** — Runs only if tests pass. Builds Docker image, tags with `:latest` and commit SHA, pushes to Docker Hub.

```yaml
# Triggered on every push to main and all PRs
on:
  push:
    branches: [main]
  pull_request:
```

Branch protection is enabled on `main` — no merge without passing CI.

### What I learned
- CI (Continuous Integration) vs CD (Delivery vs Deployment) — the real difference
- GitHub Actions YAML structure: `workflow → job → step → action`
- Why `actions/checkout@v3` must be the first step (runner has no code without it)
- Matrix builds — testing multiple Python versions in parallel
- GitHub Secrets — storing credentials securely for Docker Hub push
- `needs:` keyword — job dependency chains

---

## 🔄 Phase 3 — AWS Fundamentals (In Progress)

**Goal:** Deploy and manage cloud infrastructure using only the AWS CLI — no console clicking.

### Topics being covered
- IAM users, roles, and access keys
- EC2 — launch, SSH, configure, terminate via CLI
- S3 — create buckets, upload/download/sync files
- VPC — custom networks, public/private subnets, internet gateways
- Security Groups — port rules, inbound/outbound traffic
- AWS billing alarms — never get surprised by a bill

```bash
# Setup
aws configure
aws sts get-caller-identity

# EC2
aws ec2 run-instances --image-id <ami> --instance-type t2.micro --key-name devops-key

# S3
aws s3 cp file.txt s3://my-bucket/file.txt
aws s3 sync ./folder s3://my-bucket/folder/
```

---

## ⏳ Phase 4 — Terraform (Upcoming)

Everything done manually in Phase 3 — EC2, S3, VPC, security groups — will be reproduced entirely in `.tf` files. Infrastructure as code, version-controlled, and reproducible in seconds.

---

## ⏳ Phase 5 — Kubernetes (Upcoming)

Deploy the containerised app from Phase 1 on a local Kubernetes cluster. Rolling updates, self-healing, ConfigMaps, Secrets, resource limits, health probes.

---

## ⏳ Phase 6 — Monitoring (Upcoming)

Set up Prometheus + Grafana on the K8s cluster. Custom dashboards for CPU/memory/pod status. Alertmanager rules that fire on real conditions.

---

## ⏳ Phase 7 — Capstone Project (Upcoming)

**The full loop — everything connects:**

```
git push
  → GitHub Actions (lint + test + matrix build)
  → Docker image built + pushed (tagged with commit SHA)
  → Terraform provisions AWS infrastructure
  → Kubernetes deploys the new image (rolling update)
  → Prometheus monitors it
  → Grafana dashboard shows it's healthy
```

One repo. One push. Fully automated from code to monitored production.

---

## 🛠️ Full Tech Stack

```
Languages:        Python, Bash
Version Control:  Git, GitHub
Containerisation: Docker, Docker Compose
CI/CD:            GitHub Actions
Cloud:            AWS (EC2, S3, IAM, VPC)          ← in progress
IaC:              Terraform                          ← upcoming
Orchestration:    Kubernetes (kubectl, minikube)    ← upcoming
Monitoring:       Prometheus, Grafana               ← upcoming
OS:               Linux (Ubuntu)
```

---

## 📬 Connect

**Aaryan Dadhich** — 2nd year BTech CSE (IoT) @ MLVTEC, Bhilwara

- 🐙 GitHub: [MrDadhich456](https://github.com/MrDadhich456)
- 💼 LinkedIn: [linkedin.com/in/MrDadhich456](https://www.linkedin.com/in/aaryan-dadhich-9ba736213/)
- 📧 Email: aaryandadhich2006@gmail.com

> This repo is a live document — updated as each phase is completed.
> Star it if you're following along. ⭐