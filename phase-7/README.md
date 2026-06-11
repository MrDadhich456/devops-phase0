# Phase 7 — Production IoT Platform (NexusIoT)

## 🏭 What I Built

**NexusIoT** — A production-grade industrial IoT telemetry platform with real-time streaming, explainable anomaly detection, and full Kubernetes orchestration.

🔗 **Full Project Repository:** [github.com/MrDadhich456/NexusIoT](https://github.com/MrDadhich456/NexusIoT)

---

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **IoT Protocol** | MQTT (Mosquitto) | Device-to-cloud messaging with QoS-1 |
| **Message Bus** | Apache Kafka | Durable, replayable event streaming |
| **Database** | TimescaleDB | Time-series optimised PostgreSQL |
| **API** | FastAPI + WebSocket | REST endpoints + real-time live streams |
| **ML/XAI** | SHAP + IsolationForest | Explainable anomaly detection |
| **Orchestration** | Kubernetes (minikube) | Container orchestration |
| **IaC** | Terraform | AWS infrastructure as code (free tier) |
| **CI/CD** | GitHub Actions | Automated lint → test → build → deploy |
| **Monitoring** | Prometheus + Grafana | Metrics, dashboards, alerting |

## What I Learned

- **MQTT protocol** — how IoT devices communicate with QoS guarantees
- **Kafka as a message bus** — decoupling producers from consumers, replay capability
- **TimescaleDB hypertables** — time-series partitioning for fast range queries
- **WebSocket streaming** — real-time data push from Kafka to browser (<50ms)
- **SHAP explainability** — making ML models interpretable (why was this flagged?)
- **Kubernetes manifests** — Deployments, StatefulSets, Services, HPA, PVCs
- **Terraform provisioning** — EC2 + security groups + IAM as code
- **CI/CD pipelines** — multi-stage GitHub Actions with Docker Hub + SSH deploy
- **Prometheus custom metrics** — instrumenting application code for observability

## Architecture

```
Devices (MQTT) → Mosquitto → Kafka → Stream Processor → TimescaleDB
                                          ↓                    ↓
                                    SHAP Explainer      FastAPI + WebSocket
                                          ↓                    ↓
                                    Anomaly Alerts      Live Dashboard
```

## Key Differentiator

Unlike typical IoT projects that just collect data, NexusIoT tells you **why** an anomaly was flagged — "spindle RPM drove 68% of this anomaly" — using SHAP explainability stored as JSONB alongside every alert.
