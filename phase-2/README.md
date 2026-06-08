# Phase 2 — CI/CD with GitHub Actions

> **Goal:** Every code push automatically lints, tests, builds, and ships.
> Duration: Week 3 · Days 13–19 · ~5 hrs/day

---

## Pipeline Overview

```
git push to main
    │
    ▼
Job 1: lint-and-test
    ├── flake8 lint check
    └── pytest (Python 3.10 + 3.11 matrix — runs in parallel)
    │
    ▼ (only if Job 1 passes)
Job 2: build-and-push
    ├── Docker login (via GitHub Secrets)
    ├── Docker build
    └── Push to Docker Hub (:latest + :commit-SHA tags)
```

---

## What's Inside

### `calculator.py` — Python Application
```python
def add(a, b):      return a + b
def subtract(a, b): return a - b
def multiply(a, b): return a * b
```

### `test_calculator.py` — pytest Test Suite
```python
def test_add():           assert add(2, 3) == 5
def test_subtract():      assert subtract(5, 3) == 2
def test_multiply():      assert multiply(3, 4) == 12
def test_add_zero():      assert add(0, 0) == 0
```

### `.github/workflows/python-tests.yml` — Full Pipeline

```yaml
name: CI Pipeline
on:
  push:
    branches: [main]
  pull_request:

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install -r requirements.txt
      - run: flake8 . --max-line-length=100
      - run: pytest test_calculator.py -v

  build-and-push:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/calculator:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/calculator:${{ github.sha }}
```

---

## Key Concepts

| Concept | How it works |
|---------|-------------|
| `on: push` | Triggers workflow on every git push |
| `runs-on: ubuntu-latest` | GitHub spins up a fresh Ubuntu VM |
| `actions/checkout@v4` | Clones your repo onto the runner (required first step) |
| `needs: lint-and-test` | build-and-push only runs if lint-and-test passes |
| `matrix` | Runs tests on Python 3.10 AND 3.11 simultaneously |
| `secrets.DOCKERHUB_TOKEN` | Encrypted credential — never visible in logs |
| `github.sha` | Unique commit SHA as Docker image tag — full traceability |

---

## What I Learned

- CI vs CD (Delivery) vs CD (Deployment) — three different concepts, one acronym
- GitHub Actions runners are fresh Ubuntu machines — `checkout` is always needed
- Matrix builds: test on multiple versions without writing duplicate jobs
- `needs:` creates job dependency — failed tests block the Docker push
- GitHub Secrets: stored encrypted, referenced as `${{ secrets.NAME }}`
- Branch protection: no merge to main without passing CI — enforced at repo level
- Commit SHA tagging: every image is traceable to the exact code that built it

---

## Pass Criteria

- [x] Pipeline runs on every push to main
- [x] Lint failure blocks tests — tests failure blocks Docker push
- [x] Matrix runs both Python 3.10 and 3.11 in parallel
- [x] Docker image pushed to Docker Hub with `:latest` and `:sha` tags
- [x] Branch protection enabled — no merge without green CI
- [x] Status badge showing in README