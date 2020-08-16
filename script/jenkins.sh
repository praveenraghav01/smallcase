#!/bin/bash

echo Logging in to Amazon ECR... 
$(aws ecr get-login --region us-east-1 --no-include-email) 
REPOSITORY_URI=591616226324.dkr.ecr.us-east-1.amazonaws.com/test-eks
echo Build started on `date`
echo Building the Docker image...
docker build -t $REPOSITORY_URI .
docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:latest
echo Build completed on `date`
echo Pushing the Docker images...
docker push $REPOSITORY_URI:latest
echo Deploying the Docker image on EKS...
sudo kubectl apply -f deploy.yaml
sudo kubectl rollout restart deployment/flask
echo Deploying done on EKS... 
kubectl get service/flask-service |  awk {'print $1" " $2 " " $4 " " $5'} | column -t
