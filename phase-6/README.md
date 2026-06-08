# Phase 6 — Monitoring — Prometheus + Grafana

> **Goal:** Full observability for the Kubernetes cluster — metrics, dashboards, and alerting.
> Duration: Week 8 · Days 48–54 · ~5 hrs/day

---

## Setup via Helm

```bash
# Add Prometheus community Helm repo
helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack (includes Prometheus + Grafana + Alertmanager)
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace

# Verify pods running
kubectl get pods -n monitoring

# Access Prometheus UI
kubectl port-forward -n monitoring \
  svc/prometheus-kube-prometheus-prometheus 9090:9090
# Open: http://localhost:9090

# Access Grafana UI
kubectl port-forward -n monitoring \
  svc/prometheus-grafana 3000:80
# Open: http://localhost:3000
# Default credentials: admin / prom-operator
```

---

## Key PromQL Queries

```promql
# Is each target up?
up

# CPU usage rate (5 min window)
rate(node_cpu_seconds_total{mode="idle"}[5m])

# Container CPU usage by pod
sum(rate(container_cpu_usage_seconds_total{namespace="default"}[5m])) by (pod)

# Memory usage by pod (in MB)
sum(container_memory_usage_bytes{namespace="default"}) by (pod) / 1048576

# Pod status
kube_pod_status_phase{namespace="default"}
```

---

## Grafana Dashboard

Import pre-built Kubernetes dashboard:
- Dashboards → Import → ID: `3119`

Custom dashboard panels built:
1. **CPU usage** — time series per pod
2. **Memory usage** — gauge per pod
3. **Pod status** — stat panel

---

## Alert Rule

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: my-alerts
  namespace: monitoring
spec:
  groups:
    - name: cluster-alerts
      rules:
        - alert: HighCPU
          expr: sum(rate(container_cpu_usage_seconds_total[5m])) > 0.5
          for: 1m
          labels:
            severity: warning
          annotations:
            summary: "High CPU usage detected"
            description: "CPU usage has exceeded 50% for more than 1 minute"
```

```bash
# Apply alert rule
kubectl apply -f alert-rules.yaml -n monitoring

# Trigger test alert
kubectl run stress --image=progrium/stress -- --cpu 2

# Cleanup
helm uninstall prometheus -n monitoring
kubectl delete namespace monitoring
```

---

## Monitoring Stack Architecture

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

---

## What I Learned

- Prometheus is pull-based — it scrapes `/metrics` endpoints, apps don't push
- Metric types: Counter (only up), Gauge (up/down), Histogram (distribution)
- PromQL rate() function calculates per-second rate over a time window
- Grafana is just a visualisation layer — Prometheus is the data source
- Alertmanager handles routing, deduplication, and silencing — separate from Prometheus
- Pending → Firing: alert must breach threshold for `for:` duration before firing

---

## Pass Criteria

- [ ] Prometheus running, scraping K8s cluster targets
- [ ] CPU and memory queries returning data in Prometheus UI
- [ ] Custom Grafana dashboard with 3+ panels
- [ ] Alert rule fires when CPU threshold exceeded
- [ ] All monitoring resources cleaned up after phase