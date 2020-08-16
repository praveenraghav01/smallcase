# Small Case Assigment

## Overview

This repo contains required resources to create and deploy Flask app on AWS EKS using Jenkins pipelines.

## High Level Diagram
<p><img src ="./image/Small Case.png" /></p>

## Structure
Below is the current structure overview.
```sh
.
├── Dockerfile
├── README.md
├── app.py
├── deploy.yaml
├── image
│   └── Small\ Case.png
├── requirements.txt
├── script
│   └── jenkins.sh
└── templates
    └── index.html
```
## The jenkins.sh script

This is the main pipeline script which is used to build and deploy the application.


```sh
#!/bin/bash

echo Logging in to Amazon ECR... 
$(aws ecr get-login --region us-east-1 --no-include-email) # Get ECR login
REPOSITORY_URI=591616226324.dkr.ecr.us-east-1.amazonaws.com/test-eks  # ECR repo url
echo Build started on `date`
echo Building the Docker image...
docker build -t $REPOSITORY_URI .  # Build Docker image
docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:latest  # Tag Docker image
echo Build completed on `date`
echo Pushing the Docker images...
docker push $REPOSITORY_URI:latest  # Push Docker image
echo Deploying the Docker image on EKS...
sudo kubectl apply -f deploy.yaml # Deploy application on EKS
echo Updating current deployment...
sudo kubectl rollout restart deployment/flask # Restart deployment
echo Deploying done on EKS... 
kubectl get service/flask-service |  awk {'print $1" " $2 " " $4 " " $5'} | column -t # Print AWS Load Balancer URL
```

## Usage

To build or update this application. User have to follow the following steps.
1. Clone the repo `git clone https://github.com/praveenraghav01/smallcase.git`
2. Create a new branch from master branch `git checkout -b <branch name>`
3. Add your changes. `git add .`
3. Commit your changes. `git commit -m "commit message"`
4. Push your changes. `git push`
5. Create a merge request.
 
One your Merge Request is accepted. jenkins will automatically build and deploy new changes.
