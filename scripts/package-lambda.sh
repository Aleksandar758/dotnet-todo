#!/bin/bash
# Build and publish the application for AWS Lambda deployment
set -e

dotnet publish ../src/TodoApi.csproj -c Release -o ./publish
cd publish
zip -r ../publish.zip .
echo "Lambda deployment package created at publish.zip"