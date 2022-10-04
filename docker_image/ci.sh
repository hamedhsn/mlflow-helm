aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 551295956433.dkr.ecr.us-west-2.amazonaws.com
docker build -t 551295956433.dkr.ecr.us-west-2.amazonaws.com/ds/platform:mlflow .
docker push 551295956433.dkr.ecr.us-west-2.amazonaws.com/ds/platform:mlflow
