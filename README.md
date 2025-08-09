# dotnet-todo

A .NET Core Web API for managing todo items with complete CI/CD pipeline, containerization, and cloud deployment capabilities.

## Prerequisites

- .NET 8.0 SDK
- Docker
- Kubernetes (Minikube/MicroK8s)
- Helm
- AWS CLI
- Terraform

## Local Development

### Building and Running Locally

```bash
dotnet restore
dotnet build
dotnet run --project src/TodoApi.csproj
```

### Docker Build

```bash
docker build -t dotnet-todo:latest -f src/Dockerfile .
docker run -p 8080:80 dotnet-todo:latest
```

### Helm Deployment

```bash
# Start Minikube (if not already running)
minikube start

# Deploy using Helm
helm upgrade --install todo-api ./helm/todo-api \
  --set image.repository=dotnet-todo \
  --set image.tag=latest

# Get the service URL
minikube service todo-api --url
```

### AWS Lambda Deployment

1. Build and publish the application:
```bash
cd scripts
./package-lambda.sh
```

2. Deploy using Terraform:
```bash
cd infrastructure
terraform init
terraform apply
```

## CI/CD Pipeline

The GitHub Actions workflow implements:
- Automated builds
- Code analysis using GitHub Super-Linter
- Semantic versioning using GitVersion
- Docker image building and publishing
- Kubernetes deployment testing
- Integration tests

## Testing the API

### Available Endpoints

- GET /healthz - Health check endpoint
- GET /todoitems - List all todos
- GET /todoitems/{id} - Get a specific todo
- POST /todoitems - Create a new todo
- PUT /todoitems/{id} - Update a todo
- DELETE /todoitems/{id} - Delete a todo

### Example Request

```bash
# Get all todos
curl http://localhost:8080/todoitems

# Create a new todo
curl -X POST http://localhost:8080/todoitems \
  -H "Content-Type: application/json" \
  -d '{"name":"walk dog","isComplete":false}'
```

## Directory Structure

```
.
├── src/                    # Source code
├── helm/                   # Helm charts
│   └── todo-api/
├── infrastructure/         # Terraform AWS infrastructure
└── .github/
    └── workflows/         # GitHub Actions workflows
```

## Notes

- The application uses an in-memory database by default
- For production deployment, consider using a persistent database
- The AWS Lambda deployment includes VPC configuration for enhanced security

