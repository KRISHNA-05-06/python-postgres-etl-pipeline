# Docker Compose ETL Demo

This project is a small production-style ETL demo built with **Python**, **PostgreSQL**, **Docker**, and **Docker Compose**. It shows how to containerize a simple data pipeline, connect multiple services, and make the setup easier to run, share, and reuse.

## Project Overview

The pipeline contains two services:

- **db**: a PostgreSQL 15 database container
- **app**: a Python ETL container that connects to PostgreSQL, creates a table if it does not exist, and inserts one vegetable record

The goal of this project is not only to run an ETL job locally, but also to apply better container practices such as:

- multi-stage Docker builds
- health checks for service readiness
- environment-based configuration using `.env`
- persistent storage using Docker volumes
- running the application container as a non-root user

## Tech Stack

- Python 3.10
- PostgreSQL 15
- psycopg2-binary
- Docker
- Docker Compose

## Folder Structure

```bash
compose-demo/
├── .env
├── .env.example
├── .gitignore
├── Dockerfile
├── app.py
└── docker-compose.yaml
```

## How It Works

1. Docker Compose starts the PostgreSQL database.
2. A health check makes sure the database is actually ready.
3. The ETL app waits for the database service to become healthy.
4. The Python script connects to PostgreSQL using environment variables.
5. It creates a `vegetables` table if it does not already exist.
6. It inserts a sample row into the table.

## Files Explanation

### `app.py`
This is the ETL script. It:
- reads database connection values from environment variables
- connects to PostgreSQL
- creates the `vegetables` table
- inserts one sample row
- prints a success or error message

### `Dockerfile`
This file builds the ETL application image using a **multi-stage build**:
- the first stage installs dependencies
- the final stage copies only what is needed for runtime
- the container runs as a **non-root user** for better security

### `docker-compose.yaml`
This file defines the full multi-container stack:
- PostgreSQL database service
- ETL app service
- health checks
- environment variable injection
- persistent Docker volume for database storage

### `.env`
Stores local environment variables used by Docker Compose.
This file should **not** be pushed to GitHub if it contains real secrets.

### `.env.example`
A safe template that shows which environment variables are required.

### `.gitignore`
Prevents sensitive files like `.env` from being committed.

## Prerequisites

Before running the project, make sure you have:

- Docker installed
- Docker Compose installed
- Git installed
- A GitHub account

## Run the Project Locally

### Option 1: If `docker-compose.yaml` uses `build: .`
```bash
docker compose up --build
```

### Option 2: If `docker-compose.yaml` uses `image: etl-app:v2`
Build the image first:
```bash
docker build -t etl-app:v2 .
docker compose up
```

## Stop the Project

```bash
docker compose down
```

To also remove the volume:
```bash
docker compose down -v
```

## Example Output

```bash
ETL complete. 1 row inserted.
```

## Improvements Added

This project was improved from a simple local Docker Compose setup into a more production-ready version by adding:

- a PostgreSQL health check
- dependency startup control using `depends_on` with `service_healthy`
- a multi-stage Dockerfile
- a non-root application user
- environment-based configuration with `.env`
- persistent database storage with a named volume


## Future Enhancements

- add logging
- add unit tests
- separate extract, transform, and load logic into different modules
- schedule the ETL job with cron or Airflow
- add a data validation step
- connect the pipeline to cloud storage or a warehouse

## Author

Sri Krishna Sai Kota
