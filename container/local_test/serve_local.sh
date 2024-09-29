#!/bin/sh

# Launch a Docker container for local ML model serving
#
# This script facilitates the local deployment of a machine learning model
# within a Docker container. It's designed for testing and development purposes,
# allowing easy access to the model's serving capabilities.

# Capture the Docker image name from the first script argument
# Usage: ./serve_local.sh <docker_image_name>
image=$1

# Execute Docker container with the following configuration:
#
# 1. Volume Mounting (-v):
#    - Mounts the local 'opt_ml' directory to '/opt/ml' in the container
#    - Purpose: Provides the container access to local model files and data
#    - $(pwd) gets the current working directory to ensure correct path
#
#    Volume mounting is a Docker feature that allows sharing of directories
#    between the host system and the container. This creates a bridge between
#    the host filesystem and the container's filesystem.
#
#    In this case:
#    - The host directory: $(pwd)/opt_ml
#    - Is mounted to the container directory: /opt/ml
#
#    This means any files in the local 'opt_ml' directory will be accessible
#    inside the container at '/opt/ml'. This is particularly useful for:
#    a) Providing model files to the container without rebuilding the image
#    b) Allowing the container to write output directly to the host system
#    c) Facilitating easy updates and modifications during development
#
# 2. Port Mapping (-p 8080:8080):
#    - Maps the container's port 8080 to the host's port 8080
#    - Enables accessing the model server via localhost:8080 on the host machine
#
# 3. Auto-remove (--rm):
#    - Automatically removes the container when it stops running
#    - Helps maintain a clean development environment by preventing accumulation of stopped containers
#
# 4. Image Specification (${image}):
#    - Uses the Docker image name provided as a script argument
#
# 5. Command (serve):
#    - Runs the 'serve' command inside the container
#    - This typically starts the model server or prediction service

docker run -v $(pwd)/opt_ml:/opt/ml -p 8080:8080 --rm ${image} serve
