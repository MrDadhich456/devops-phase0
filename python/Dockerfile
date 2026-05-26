# 1. Base Image: Use a tiny Linux OS with Python 3.11 pre-installed
FROM python:3.11-slim

# 2. Workspace: Create a folder inside the container and move into it
WORKDIR /app

# 3. Dependencies FIRST (Layer Caching): Copy ONLY the requirements file
COPY requirements.txt .

# 4. Install libraries. (Docker will cache this step unless requirements.txt changes!)
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your code into the container
COPY . .

# 6. Execution Rules (ENTRYPOINT vs CMD)
# ENTRYPOINT is the hardcoded command that WILL run.
ENTRYPOINT ["python", "fetcher.py"]

# CMD provides the default arguments, but the user can overwrite them.
CMD ["--user-id", "1"]
