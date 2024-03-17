#!/bin/bash

set -e

# Variables
DOCKER_USERNAME="tsulatsitamim"
IMAGE_NAME="nginx"
TAG="latest"

# Build Docker image
docker build -t $DOCKER_USERNAME/$IMAGE_NAME:$TAG .

# Login to Docker Hub
docker login -u $DOCKER_USERNAME

# Push Docker image to Docker Hub
docker push $DOCKER_USERNAME/$IMAGE_NAME:$TAG
