# Phase 5 — Kubernetes

> **Goal:** Deploy containerised applications with self-healing, rolling updates, and proper resource management.
> Duration: Weeks 6–7 · Days 34–47 · ~5 hrs/day

---

## Setup

```bash
# Install and start minikube
minikube start
minikube status

# Verify cluster
kubectl get nodes
kubectl get pods --all-namespaces
```

---

## Manifest Files

### `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: mrdadhich456/calculator:latest
          ports:
            - containerPort: 8080
          resources:
            requests:
              memory: "64Mi"
              cpu: "250m"
            limits:
              memory: "128Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 5
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 3
          envFrom:
            - configMapRef:
                name: app-config
          env:
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: DB_PASSWORD
```

### `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-svc
  namespace: dev
spec:
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
  type: NodePort
```

### `configmap.yaml`

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  API_URL: "https://api.example.com"
  LOG_LEVEL: "INFO"
```

---

## Key Commands

```bash
# Apply manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f configmap.yaml

# Monitor
kubectl get pods -n dev -w
kubectl describe pod <name> -n dev
kubectl logs <name> -n dev
kubectl logs <name> --previous

# Exec into pod
kubectl exec -it <name> -- bash

# Scale
kubectl scale deployment my-app --replicas=5 -n dev

# Rolling update
kubectl set image deployment/my-app my-app=mrdadhich456/calculator:v2
kubectl rollout status deployment/my-app

# Rollback
kubectl rollout undo deployment/my-app
kubectl rollout history deployment/my-app

# Port forward (debug)
kubectl port-forward pod/<name> 8080:8080

# Access via minikube
minikube service my-app-svc --url -n dev

# Namespaces
kubectl create namespace dev
kubectl create namespace staging
kubectl config set-context --current --namespace=dev

# Secrets
kubectl create secret generic db-secret \
  --from-literal=DB_PASSWORD=mysecretpassword
```

---

## Concepts Covered

| Concept | What I built to learn it |
|---------|--------------------------|
| Self-healing | Deleted a pod — watched K8s recreate it automatically |
| Rolling updates | Updated to v2 image — zero downtime, pods replaced one by one |
| Rollback | Pushed broken image — rolled back with one command |
| ConfigMaps | Non-sensitive config injected as env vars |
| Secrets | DB password injected at runtime — not in image |
| Resource limits | CPU/memory requests and limits set on containers |
| Liveness probe | Container restarted when /health returns 500 |
| Readiness probe | Pod removed from Service until /ready returns 200 |
| Namespaces | Dev and staging environments isolated in same cluster |

---

## Architecture

```
                    minikube cluster
                         │
              ┌──────────┴──────────┐
              │    Namespace: dev    │
              │                     │
              │   Service (NodePort) │
              │         │           │
              │   ┌─────┴─────┐     │
              │   │  Pod 1    │     │
              │   │  Pod 2    │ ←── ReplicaSet (desired: 3)
              │   │  Pod 3    │     │
              │   └───────────┘     │
              │                     │
              │  ConfigMap / Secret  │
              └─────────────────────┘
```

---

## What I Learned

- Pod vs Deployment — never run bare pods in production, always use Deployments
- ReplicaSet maintains desired replica count — self-healing is automatic
- Services provide stable network identity — pods have dynamic IPs that change on restart
- ConfigMaps for config, Secrets for sensitive data — never hardcode in Docker images
- Rolling updates replace pods one at a time — zero downtime deployments
- Resource requests = minimum guaranteed, limits = maximum allowed
- Liveness probe = K8s restarts pod on failure
- Readiness probe = K8s removes pod from Service on failure (stops sending traffic)
- Namespaces organise workloads — dev/staging/prod can coexist in one cluster

---

## Pass Criteria

- [x] 3 replicas deployed, all Running
- [x] Self-healing verified — deleted pod replaced automatically
- [x] Rolling update to v2 — zero downtime
- [x] Rollback after broken image — v1 restored
- [x] ConfigMap + Secret injected as env vars in pod
- [x] Resource limits and health probes configured
- [x] Dev and staging namespaces created and isolated