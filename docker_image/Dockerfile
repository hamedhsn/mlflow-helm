FROM python:3.9
# RUN apt update && apt install -y python3-venv gcc
# RUN apt-get install -y python3-dev build-essential

RUN pip install -U pip && pip install -U mlflow boto3 gcsfs psycopg2-binary google-cloud-storage pymysql --upgrade

# Expose the port that the MLFlow tracking server runs on
EXPOSE 5000

