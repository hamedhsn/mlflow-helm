FROM python:3.9
RUN apt update && apt install -y python3-venv gcc
RUN apt-get install -y python3-dev build-essential

ENV VENV=/.venv/myenv
RUN python3 -m venv ${VENV}
RUN mkdir -p $VENV/src
ENV PATH=$VENV/bin:$PATH
RUN pip install -U pip && pip install psycopg2 mlflow google-cloud google-cloud-storage

# Expose the port that the MLFlow tracking server runs on
EXPOSE 5000

# Default database credentials
ENV DATABASE_USER=postgres
ENV DATABASE_PASSWORD=mlflow
ENV DATABASE_NAME=mlflow-tracking-server-db
ENV DATABASE_URL=mlflow-postgresql
ENV DATABASE_PORT=5432
ENV ARTIFACT_STORE=s3://bis-nonprod-ds/mlflow

ENTRYPOINT mlflow server \
        --default-artifact-root $ARTIFACT_STORE \
        --backend-store-uri postgresql://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_URL:$DATABASE_PORT/$DATABASE_NAME --host 0.0.0.0
