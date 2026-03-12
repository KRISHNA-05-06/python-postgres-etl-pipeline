FROM python:3.10-slim AS builder

WORKDIR /app
COPY app.py .
RUN pip install --target=/tmp/deps psycopg2-binary

# Final stage
FROM python:3.10-slim

WORKDIR /app
COPY --from=builder /app/app.py .
COPY --from=builder /tmp/deps /usr/local/lib/python3.10/site-packages/

RUN useradd -m etluser
USER etluser

CMD ["python", "app.py"]