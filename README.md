# ☁️ cloud-ops — DevOps & Cloud Engineering Roadmap

> A complete, hands-on DevOps learning journey — from Linux fundamentals to a fully automated, production-grade IoT platform deployed on Kubernetes.
> Built by **Aaryan Dadhich** | BTech CSE (IoT) @ MLVTEC, Bhilwara

[![CI Pipeline](https://github.com/MrDadhich456/cloud-ops/actions/workflows/python-tests.yml/badge.svg)](https://github.com/MrDadhich456/cloud-ops/actions/workflows/python-tests.yml)
![Phases Complete](https://img.shields.io/badge/Phases%20Complete-8%2F8-brightgreen)
![Tools](https://img.shields.io/badge/Tools-Bash%20%7C%20Python%20%7C%20Docker%20%7C%20GitHub%20Actions%20%7C%20AWS%20%7C%20Terraform%20%7C%20Kubernetes%20%7C%20Prometheus%20%7C%20Grafana-informational)

---

## 🗺️ Roadmap Progress

| Phase | Topic | Status | Key Tools |
|-------|-------|--------|-----------|
| Phase 0 | Linux, Bash, Git, Python | ✅ Complete | Bash, Python, Git, Linux |
| Phase 1 | Docker & Containerisation | ✅ Complete | Docker, docker-compose, Docker Hub |
| Phase 2 | CI/CD with GitHub Actions | ✅ Complete | GitHub Actions, pytest, flake8 |
| Phase 3 | AWS Fundamentals | ✅ Complete | AWS CLI, EC2, S3, IAM, VPC |
| Phase 4 | Infrastructure as Code | ✅ Complete | Terraform, HCL |
| Phase 5 | Kubernetes | ✅ Complete | minikube, kubectl, Helm |
| Phase 6 | Monitoring | ✅ Complete | Prometheus, Grafana, Alertmanager |
| Phase 7 | Capstone — NexusIoT | ✅ Complete | MQTT, Kafka, SHAP, FastAPI, K8s |

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
├── phase-3/                    # AWS Fundamentals
│   └── README.md
│
├── phase-4/                    # Terraform — Infrastructure as Code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
│
├── phase-5/                    # Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── README.md
│
├── phase-6/                    # Monitoring — Prometheus + Grafana
│   ├── alert-rules.yaml
│   └── README.md
│
├── phase-7/                    # Capstone — NexusIoT Platform
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

**`python/fetcher.py`** — CLI API data fetcher
- Fetches posts from a public API with `requests`
- Filter by `--user-id` argument via `argparse`
- Full error handling: `ConnectionError`, `Timeout`, invalid inputs
- Structured logging: INFO / WARNING / ERROR levels

```bash
cd python
pip install -r requirements.txt
python fetcher.py --user-id 3
```

### What I learned
- Linux file permissions (`chmod`), process management (`ps`, `lsof`), disk inspection (`df`, `du`)
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
docker build -t cloud-ops:v1 .
docker run cloud-ops:v1

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

### Pipeline jobs
1. **lint-and-test** — `flake8` + `pytest` on Python 3.10 AND 3.11 simultaneously
2. **build-and-push** — runs only if tests pass; builds Docker image, tags with `:latest` and commit SHA, pushes to Docker Hub

```yaml
on:
  push:
    branches: [main]
  pull_request:
```

Branch protection enabled on `main` — no merge without passing CI.

### What I learned
- CI vs CD (Delivery vs Deployment) — the real difference
- GitHub Actions YAML: `workflow → job → step → action`
- Why `actions/checkout@v3` must be the first step
- Matrix builds — testing multiple Python versions in parallel
- GitHub Secrets — storing credentials securely
- `needs:` keyword — job dependency chains

---

## ✅ Phase 3 — AWS Fundamentals

**Goal:** Deploy and manage cloud infrastructure using only the AWS CLI — zero console clicks.

### Core Competencies

**Identity & Access Management (IAM):** Enforced least privilege by provisioning dedicated IAM admin users and generating access keys — never touched the root account.

**Compute (EC2):** Provisioned, configured, and SSH-accessed instances from the terminal using cryptographic key pairs (`.pem`).

**Networking (VPC):** Engineered a custom VPC from scratch — public/private subnets, internet gateways, and custom route tables for network isolation.

**Security Groups:** Configured zero-trust ingress rules for HTTP (80) and SSH (22) — all other traffic denied.

**Object Storage (S3):** Provisioned buckets and synced local directories to cloud storage via CLI.

**FinOps:** Implemented CloudWatch + SNS billing alarm — email alert triggered when costs exceed $1.00.

```bash
# Identity verification
aws configure
aws sts get-caller-identity

# Launch EC2
aws ec2 run-instances --image-id <ami> --instance-type t3.micro \
  --key-name devops-key --security-group-ids <sg-id>

# Billing alarm
aws cloudwatch put-metric-alarm --alarm-name "Billing-1USD" \
  --metric-name EstimatedCharges --namespace AWS/Billing \
  --statistic Maximum --threshold 1 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions <SNS_TOPIC_ARN>
```

### What I learned
- IAM is AWS security rule #1 — never use root for daily work
- Public subnet = route to internet gateway. Private subnet = no internet route
- CLI-first approach forces understanding of every parameter
- Always terminate resources — t2.micro costs money even idle

---

## ✅ Phase 4 — Infrastructure as Code — Terraform

**Goal:** Translate manual AWS CLI architecture into version-controlled, declarative HCL.

### Core Competencies

**Declarative Provisioning:** Replaced manual scripting with stateful deployments — VPCs, Security Groups, EC2, and S3 defined in centralized `.tf` configuration.

**Modular Architecture:** Dynamic, reusable file structure: `main.tf`, `variables.tf`, `outputs.tf` — no hardcoded values.

**Secrets Management:** Isolated sensitive parameters into `.tfvars` files excluded from version control via `.gitignore`.

**Remote State:** Migrated `terraform.tfstate` to a centralized, encrypted AWS S3 backend — enabling multi-developer collaboration and CI/CD integration.

**Infrastructure Lifecycle:** Full Terraform workflow — plan dry-runs, safe applies, and clean destroys for zero-waste cloud usage.

```bash
# Initialize workspace and S3 backend
terraform init

# Validate and dry-run
terraform fmt
terraform plan

# Deploy
terraform apply -var-file="secrets.tfvars"

# Clean teardown
terraform destroy
```

### What I learned
- Terraform state is the brain — never manually edit `.tfstate`
- `terraform plan` shows drift between desired and actual state
- `terraform refresh` syncs state with reality after manual AWS changes
- Remote state in S3 is essential for team workflows
- Variables + outputs make configs reusable and safe

---

## ✅ Phase 5 — Kubernetes

**Goal:** Deploy containerised applications on a Kubernetes cluster with self-healing, rolling updates, and proper resource management.

### Core Competencies

**Cluster Setup:** Provisioned a local single-node cluster using minikube. Configured `kubectl` for cluster interaction.

**Workloads:** Deployed applications using Deployments with 3 replicas. Validated self-healing — deleted pods restart automatically via ReplicaSet controller.

**Networking:** Exposed applications using Services (ClusterIP, NodePort). Understood label selectors for pod targeting.

**Configuration Management:** Injected non-sensitive config via ConfigMaps and sensitive data via Secrets as environment variables — never hardcoded in images.

**Rolling Updates & Rollbacks:** Updated deployments to new image versions with zero downtime. Simulated failed deployments and executed instant rollbacks.

**Resource Management:** Set CPU/memory `requests` and `limits`. Configured liveness and readiness probes for production-grade health checking.

**Namespaces:** Organised cluster workloads into `dev` and `staging` namespaces for environment isolation.

```bash
# Start cluster
minikube start

# Deploy application
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Monitor
kubectl get pods -w
kubectl describe pod <name>
kubectl logs <name>

# Rolling update
kubectl set image deployment/my-app my-app=image:v2
kubectl rollout status deployment/my-app

# Rollback
kubectl rollout undo deployment/my-app

# Scale
kubectl scale deployment my-app --replicas=5

# Access app
minikube service my-app-svc --url
```

### What I learned
- Pod vs Deployment — never run bare pods in production
- ReplicaSet controller maintains desired replica count automatically (self-healing)
- Services provide stable network identity — pods have dynamic IPs
- ConfigMaps for config, Secrets for sensitive data — never hardcode in images
- Rolling updates replace pods one at a time — zero downtime deployments
- Resource limits prevent one app from starving others on the cluster
- Liveness probe = restart on failure. Readiness probe = remove from Service on failure

---

## ✅ Phase 6 — Monitoring — Prometheus + Grafana

**Goal:** Full observability for the Kubernetes cluster — metrics collection, dashboards, and automated alerting.

### Core Competencies

**Stack Deployment:** Installed the full `kube-prometheus-stack` via Helm — Prometheus, Grafana, and Alertmanager deployed as a single chart in a dedicated `monitoring` namespace.

**PromQL Queries:** Wrote and executed production-grade queries — CPU usage rates, per-pod memory consumption, container resource utilisation, and pod status tracking.

**Grafana Dashboards:** Built custom dashboards with 3+ panels (CPU time series, memory gauges, pod status stats). Imported community dashboards (ID `3119`) for cluster-wide visibility.

**Alert Rules:** Authored `PrometheusRule` CRDs to fire alerts when CPU usage exceeds thresholds for sustained periods. Validated alerting by stress-testing pods.

**Architecture Understanding:** Prometheus scrapes `/metrics` endpoints (pull-based). Alertmanager handles routing, deduplication, and silencing. Grafana is the visualisation layer.

```bash
# Install via Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace

# Access Prometheus UI
kubectl port-forward -n monitoring \
  svc/prometheus-kube-prometheus-prometheus 9090:9090

# Access Grafana
kubectl port-forward -n monitoring \
  svc/prometheus-grafana 3000:80

# Apply custom alert rules
kubectl apply -f alert-rules.yaml -n monitoring

# Stress test to trigger alerts
kubectl run stress --image=progrium/stress -- --cpu 2
```

### Key PromQL queries used

```promql
# Target health
up

# CPU usage rate (5 min window)
rate(node_cpu_seconds_total{mode="idle"}[5m])

# Container CPU usage by pod
sum(rate(container_cpu_usage_seconds_total{namespace="default"}[5m])) by (pod)

# Memory usage by pod (in MB)
sum(container_memory_usage_bytes{namespace="default"}) by (pod) / 1048576
```

### Monitoring architecture

```
App pods ──── /metrics endpoint
                    │
                    ▼ (scrape every 15s)
              Prometheus
                    │
          ┌─────────┴─────────┐
          │                   │
       Grafana           Alertmanager
    (dashboards)        (routes alerts)
                              │
                    ┌─────────┴─────────┐
                  Slack              Email
```

### What I learned
- Prometheus is pull-based — it scrapes `/metrics` endpoints, apps don't push
- Metric types: Counter (only up), Gauge (up/down), Histogram (distribution)
- PromQL `rate()` function calculates per-second rate over a time window
- Grafana is just a visualisation layer — Prometheus is the data source
- Alertmanager handles routing, deduplication, and silencing — separate from Prometheus
- Pending → Firing: alert must breach threshold for `for:` duration before firing

---

## ✅ Phase 7 — Capstone Project — NexusIoT

**Goal:** Bring every skill together — build a production-grade industrial IoT platform from scratch.

### 🏭 What I built

**NexusIoT** — A production-grade industrial IoT telemetry platform with real-time streaming, explainable anomaly detection, and full Kubernetes orchestration.

🔗 **Full Project Repository:** [github.com/MrDadhich456/NexusIoT](https://github.com/MrDadhich456/NexusIoT)

### End-to-end pipeline

```
git push
  → GitHub Actions (lint + test + matrix build)
  → Docker image built + pushed (tagged with commit SHA)
  → Terraform provisions AWS infrastructure
  → Kubernetes deploys the new image (rolling update)
  → Prometheus monitors it
  → Grafana dashboard shows it's healthy
```

### Tech stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **IoT Protocol** | MQTT (Mosquitto) | Device-to-cloud messaging with QoS-1 |
| **Message Bus** | Apache Kafka | Durable, replayable event streaming |
| **Database** | TimescaleDB | Time-series optimised PostgreSQL |
| **API** | FastAPI + WebSocket | REST endpoints + real-time live streams |
| **ML/XAI** | SHAP + IsolationForest | Explainable anomaly detection |
| **Orchestration** | Kubernetes (minikube) | Container orchestration |
| **IaC** | Terraform | AWS infrastructure as code |
| **CI/CD** | GitHub Actions | Automated lint → test → build → deploy |
| **Monitoring** | Prometheus + Grafana | Metrics, dashboards, alerting |

### Architecture

```
Devices (MQTT) → Mosquitto → Kafka → Stream Processor → TimescaleDB
                                          ↓                    ↓
                                    SHAP Explainer      FastAPI + WebSocket
                                          ↓                    ↓
                                    Anomaly Alerts      Live Dashboard
```

### Key differentiator

Unlike typical IoT projects that just collect data, NexusIoT tells you **why** an anomaly was flagged — _"spindle RPM drove 68% of this anomaly"_ — using SHAP explainability stored as JSONB alongside every alert.

### What I learned
- **MQTT protocol** — how IoT devices communicate with QoS guarantees
- **Kafka as a message bus** — decoupling producers from consumers, replay capability
- **TimescaleDB hypertables** — time-series partitioning for fast range queries
- **WebSocket streaming** — real-time data push from Kafka to browser (<50ms)
- **SHAP explainability** — making ML models interpretable (why was this flagged?)
- **Kubernetes manifests** — Deployments, StatefulSets, Services, HPA, PVCs
- **Terraform provisioning** — EC2 + security groups + IAM as code
- **CI/CD pipelines** — multi-stage GitHub Actions with Docker Hub + SSH deploy
- **Prometheus custom metrics** — instrumenting application code for observability

---

## 🛠️ Full Tech Stack

```
Languages:        Python, Bash
Version Control:  Git, GitHub
Containerisation: Docker, Docker Compose
CI/CD:            GitHub Actions
Cloud:            AWS (EC2, S3, IAM, VPC)
IaC:              Terraform
Orchestration:    Kubernetes (kubectl, minikube, Helm)
Monitoring:       Prometheus, Grafana, Alertmanager
IoT:              MQTT (Mosquitto), Apache Kafka
ML/XAI:           SHAP, IsolationForest
API:              FastAPI, WebSocket
Database:         TimescaleDB (PostgreSQL)
OS:               Linux (Ubuntu)
```

---

## 📬 Connect

**Aaryan Dadhich** — 2nd year BTech CSE (IoT) @ MLVTEC, Bhilwara

- 🐙 GitHub: [MrDadhich456](https://github.com/MrDadhich456)
- 💼 LinkedIn: [linkedin.com/in/MrDadhich456](https://www.linkedin.com/in/MrDadhich456)
- 📧 Email: aaryandadhich2006@gmail.com

> 🎉 All 8 phases complete — from `chmod +x` to a production IoT platform on Kubernetes.
> Star it if you found it useful. ⭐