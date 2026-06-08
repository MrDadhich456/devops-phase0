# Phase 1 — Docker & Containerisation

> **Goal:** Package any application to run consistently anywhere.
> Duration: Week 2 · Days 6–12 · ~5 hrs/day

---

## What's Inside

### `Dockerfile` — Production-Ready Image
Built using `python:3.11-slim` with layer caching optimisation.

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .          # deps first — cached unless changed
RUN pip install -r requirements.txt
COPY . .                         # code last — cache invalidated only here
CMD ["python", "fetcher.py", "--user-id", "1"]
```

### `docker-compose.yml` — Multi-Container Setup
Runs the Python app alongside a Postgres database on a shared network.

```yaml
services:
  app:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
    environment:
      - DB_HOST=db
  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

---

## Key Commands

```bash
# Build and run
docker build -t cloud-ops:v1 .
docker run cloud-ops:v1
docker run -p 8080:80 cloud-ops:v1

# Volume mount (persist output locally)
docker run -v $(pwd)/output:/app/output cloud-ops:v1

# Multi-container
docker-compose up
docker-compose up -d
docker-compose down -v

# Inspection
docker ps -a
docker images
docker logs -f <container-id>
docker exec -it <container-id> bash

# Networking
docker network create mynet
docker run --network mynet --name app cloud-ops:v1

# Docker Hub
docker tag cloud-ops:v1 mrdadhich456/cloud-ops:v1
docker push mrdadhich456/cloud-ops:v1
docker pull mrdadhich456/cloud-ops:v1

# Cleanup
docker system prune -f
docker volume prune
```

---

## Concepts Covered

| Concept | What I built to learn it |
|---------|--------------------------|
| Container vs VM | Ran Ubuntu container, compared to full VM overhead |
| Layer caching | Reordered Dockerfile — deps before code |
| ENTRYPOINT vs CMD | Passed `--user-id` flag at runtime |
| Bridge networking | Two containers pinging each other by name |
| Bind mounts | Output file appearing on local machine |
| Named volumes | Postgres data surviving `docker-compose down` |
| Docker Hub | Pushed image, pulled on fresh environment |

---

## What I Learned

- Containers share the host OS kernel — that's why they're fast and lightweight
- Layer caching: COPY requirements.txt before COPY . . saves rebuild time
- ENTRYPOINT is the fixed executable, CMD provides default arguments
- Docker bridge networking: containers find each other by service name, not IP
- Named volumes persist data beyond container lifecycle — critical for databases
- `docker system prune` removes stopped containers, unused networks, dangling images

---

## Pass Criteria

- [x] Custom Docker image builds and runs correctly
- [x] docker-compose starts app + Postgres together
- [x] Volume mount saves output to local machine
- [x] Two containers on same network communicate by name
- [x] Image pushed to Docker Hub and pullable from URL alone