#!/bin/sh

# This script is used to run a local training job using a Docker container.
# It sets up the necessary directories, cleans up any existing files,
# and then launches a Docker container to perform the training.

# Get the Docker image name from the first command-line argument
image=$1

# Create directories for the model and output
# The -p flag ensures that parent directories are created if they don't exist
mkdir -p opt_ml/model
mkdir -p opt_ml/output

# Remove any existing files in the model and output directories
# This ensures a clean state for each training run
rm opt_ml/model/*
rm opt_ml/output/*

# Run the Docker container for training
# Explanation of the docker run command:
# -v $(pwd)/test_dir:/opt/ml : Mounts the local 'test_dir' to '/opt/ml' in the container
# --rm : Automatically remove the container when it exits
# ${image} : Use the Docker image specified by the user
# train : Run the 'train' command inside the container
docker run -v $(pwd)/test_dir:/opt/ml --rm ${image} train
