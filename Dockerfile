FROM python:3.12-slim

WORKDIR /app

COPY calculator.py .

CMD ["python", "-c", "import calculator; print('Calculator container successfully built and loaded!')"]
