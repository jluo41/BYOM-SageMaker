#!/usr/bin/env bash

# This script shows how to build the Docker image and push it to ECR to be ready for use
# by SageMaker.

# The argument to this script is the image name. This will be used as the image on the local
# machine and combined with the account and region to form the repository name for ECR.
image=$1 # The name of the image to build and push

# Check if an image name was provided as an argument. If not, display usage instructions and exit.
if [ "$image" == "" ]
then
    echo "Usage: $0 <image-name>"
    exit 1
fi

# Make the 'train' and 'serve' scripts executable. These are likely entry points for the SageMaker container.
# chmod +x linear_regression/train
# chmod +x linear_regression/serve
chmod +x app_name/train
chmod +x app_name/serve

# Get the account number associated with the current IAM credentials
account=$(aws sts get-caller-identity --query Account --output text)

# Check if the AWS CLI command was successful. If not, exit with a status code of 255.
if [ $? -ne 0 ]
then
    exit 255
fi


# Get the region defined in the current configuration (default to us-east-1 if none defined)
region=$(aws configure get region)
region=${region:-us-east-1}


# Construct the full name for the ECR repository, including account ID, region, image name, and 'latest' tag.
fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image}:latest"

# If the repository doesn't exist in ECR, create it.

# Check if the repository already exists in ECR. Output is discarded as we only care about the exit status.
aws ecr describe-repositories --repository-names "${image}" > /dev/null 2>&1

# If the repository doesn't exist (i.e., the previous command failed), create it.
if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${image}" > /dev/null
fi

# Get the login command from ECR and execute it directly
# This authenticates Docker to the ECR registry using the AWS CLI to retrieve a token.
aws ecr get-login-password --region "${region}" | docker login --username AWS --password-stdin "${account}".dkr.ecr."${region}".amazonaws.com

# Build the docker image locally with the image name and then push it to ECR
# with the full name.

# Build the Docker image locally, tagging it with the provided image name.
# Build the Docker image locally
# This command builds a Docker image using the Dockerfile in the current directory (.)
# The -t flag tags the image with the name stored in the ${image} variable
# 
# When this code runs:
# 1. Docker will look for a Dockerfile in the current directory
# 2. It will execute the instructions in the Dockerfile to create a new image
# 3. The new image will be tagged with the name specified in ${image}
# 4. If successful, you'll have a new Docker image available locally
#
# Note: This step is crucial for creating the container that will be pushed to ECR
docker build  -t ${image} .

# Tag the local image with the full ECR repository name, preparing it for pushing to ECR.
docker tag ${image} ${fullname}

# Push the tagged image to the ECR repository, making it available for use with SageMaker.
docker push ${fullname}
