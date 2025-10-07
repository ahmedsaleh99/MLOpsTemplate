# Makefile

ENV_NAME ?= mlops_env
DEP_FILE ?= requirements.yaml
DEV_FILE ?= requirements-dev.yaml

# Docker image settings (can be overridden via environment or CLI: e.g. `make docker-build IMAGE_TAG=v1 DOCKER_REG=myreg`)
IMAGE_NAME ?= mlopstemplate
IMAGE_TAG ?= latest
DOCKERFILE ?= Dockerfile
DOCKER_REG ?= YOUR_DOCKER_REG


IMAGE ?= $(DOCKER_REG)/$(IMAGE_NAME):$(IMAGE_TAG)


# Choose installer command depending on OS. On Windows (cmd/PowerShell) the
# environment variable OS is typically set to Windows_NT. On Unix-like systems
# use the POSIX shell script.
ifeq ($(OS),Windows_NT)
	# Use PowerShell to run the script; keep ExecutionPolicy bypass for automation
	RUN_INSTALL = powershell -NoProfile -ExecutionPolicy Bypass -File ./scripts/install_env.ps1
else
	RUN_INSTALL = sh ./scripts/install_env.sh
endif

.PHONY: prod-env  dev-env dev-depend format tests docker-build docker-push docker docker-env


prod-env:
	@echo "Running installer for $(ENV_NAME) $(DEP_FILE) [prod]"
	@$(RUN_INSTALL) prod $(ENV_NAME) $(DEP_FILE)

dev-depend:
	@echo "Running installer for $(ENV_NAME) $(DEV_FILE) [dev]"
	@$(RUN_INSTALL) dev $(ENV_NAME) $(DEV_FILE)

dev-docker:
	@echo "Running installer for $(ENV_NAME) $(DEV_FILE) [docker]"
	@$(RUN_INSTALL) docker $(ENV_NAME) $(DEV_FILE)

dev-env: prod-env dev-depend

docker-env: prod-env dev-docker

format:
	@echo "Formatting code with Ruff..."
	@conda run -n $(ENV_NAME) ruff format
	@echo "Linting code With Ruff ..."
	@conda run -n $(ENV_NAME) ruff check  --fix
	

tests:
	@echo "Checking Formatting & Linting with Ruff..."
	@conda run -n $(ENV_NAME) ruff check
	@echo "Running tests with pytest..."
	@conda run -n $(ENV_NAME) pytest tests


docker-build:
	@echo "Building Docker image $(IMAGE) using $(DOCKERFILE)..."
	@docker build -f $(DOCKERFILE) -t $(IMAGE) .


docker-push:
	@echo "Pushing Docker image $(IMAGE)..."
	@docker push $(IMAGE)


docker: docker-build docker-push
	@echo "Docker image $(IMAGE) built and pushed."


