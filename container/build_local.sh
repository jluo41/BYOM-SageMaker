#!/usr/bin/env bash

# This script shows how to build the Docker image locally

# The argument to this script is the image name. This will be used as the image tag on the local machine.
image=$1 # The name of the image to build

# Check if an image name was provided as an argument. If not, display usage instructions and exit.
if [ "$image" == "" ]
then
    echo "Usage: $0 <image-name>"
    exit 1
fi

# Check if the image already exists
if docker image inspect ${image} > /dev/null 2>&1; then
    echo "Docker image '${image}' already exists. Deleting the old image."
    docker rmi ${image}
fi

# Make the 'train' and 'serve' scripts executable, if they are part of your Docker container's build process.
chmod +x opt_program/train
chmod +x opt_program/serve

# Build the Docker image locally, tagging it with the provided image name.
# This command builds a Docker image using the Dockerfile in the current directory.
docker build -t ${image} .

echo "Docker image '${image}' built successfully."
