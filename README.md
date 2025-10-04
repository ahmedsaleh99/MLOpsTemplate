# MLOpsTemplate

A starter template for machine learning projects with MLOps best practices.

## Prerequisites

Ensure you have the following installed:

- [GNU Make](https://www.gnu.org/software/make/) – for build automation  
- [Miniforge](https://github.com/conda-forge/miniforge) – a minimal conda installer

## Getting Started

### Clone the Repository

```bash
git clone git@github.com:ahmedsaleh99/MLOpsTemplate.git
cd MLOpsTemplate
```

### Set Up the Conda Environment

To create the production environment (main dependencies):

```bash
make prod-env
```

Or, to set up the full development environment:

```bash
make dev-env
```

After setup, activate your environment (replace `[your_env_name]`):

```bash
conda activate [your_env_name]
```

## Contribution Guide

### Format and Lint Code

Format and fix linting issues using Ruff:

```bash
make format
```

### Run Tests

Run the test suite:

```bash
make tests
```

### Build Docker Image

To build a Docker image locally:

```bash
make docker-build IMAGE_TAG=v1 DOCKER_REG=docker_hub_user
```

To push the built image to Docker Hub:

```bash
make docker-push IMAGE_TAG=v1 DOCKER_REG=docker_hub_user
```

## CI/CD Pipeline

This template uses GitHub Actions for CI/CD. Workflow files are in `.github/workflows/`. The pipeline pulls the Docker image from Docker Hub and runs tests on it. When your environment changes, update and push your Docker image, then update the workflow to use the new image tag.
