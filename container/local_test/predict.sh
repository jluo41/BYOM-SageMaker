#!/bin/bash

# This script sends a prediction request to a locally running ML model server.

# Get the payload file from the first command-line argument
payload=$1

# Set the content type, defaulting to 'text/csv' if not provided
# ${2:-text/csv} means: use the second command-line argument if provided, otherwise use 'text/csv'
content=${2:-text/csv}

# Send a POST request to the local server using curl
# --data-binary @${payload}: Send the contents of the file specified by $payload as the request body
# -H "Content-Type: ${content}": Set the Content-Type header to the value in $content
# -v: Enable verbose output for debugging
# http://localhost:8080/invocations: The endpoint URL of the local server
curl --data-binary @${payload} -H "Content-Type: ${content}" -v http://localhost:8080/invocations

# Example usage:
# ./predict.sh payload.csv
# This will send the contents of payload.csv to the server with Content-Type: text/csv
#
# ./predict.sh payload.json application/json
# This will send the contents of payload.json to the server with Content-Type: application/json
