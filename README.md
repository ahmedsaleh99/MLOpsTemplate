[![Python Version](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/ahmedsaleh99/MLOpsTemplate/)

# MLOpsTemplate
This is a template for a machine learning project.

## Prerequisites

Before running the code, make sure you have the following installed:

- [GNU Make](https://www.gnu.org/software/make/) – a build automation tool  
- [Miniforge](https://github.com/conda-forge/miniforge) – a minimal installer for conda (community-driven)



## Getting Started

### Clone the repository

   ```bash
   git clone git@github.com:ahmedsaleh99/benchmark_oak_cam.git
   cd benchmark_oak_cam
   ```

### Set Up the Conda Environment


Create Production environment (install main dependencies):

```bash
make prod-env
```

Alternatively, create the full development environment in one step:
```bash
make dev-env
```

After this, the conda environment annotation will be ready. Activate it if not already active:

```bash
conda activate annotation
```
### Format and Lint Code

```bash
make format
```

This will format code using Ruff and automatically fix linting issues.

### Run Tests

```bash
make test
```
