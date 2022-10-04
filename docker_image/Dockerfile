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

