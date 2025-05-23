# Makefile

ENV_NAME = MLopsEnv
DEP_FILE = requirements.yaml
DEV_FILE = requirements-dev.yaml

.PHONY: create-env  install-dev format test


create-env:
	@echo "Removing conda environment $(ENV_NAME) if exists..."
	@conda env remove -n $(ENV_NAME) -y --quiet || echo "Environment $(ENV_NAME) does not exist."

	@echo "Creating conda environment with name $(ENV_NAME)..."
	@conda env create -n $(ENV_NAME) --file $(DEP_FILE) -y -q
	@echo "Environment '$(ENV_NAME)' created successfully!"
	@echo "To activate, run: conda activate $(ENV_NAME)"

install-dev:
	@echo "Installing development dependencies into '$(ENV_NAME)' from $(DEV_FILE)..."
	@conda env update -n $(ENV_NAME) --file $(DEV_FILE) -q
	@echo "Development dependencies installed!"

format:
	@echo "Formatting code with black..."
	@conda run -n $(ENV_NAME) black src tests
	@echo "Running flake8..."
	@conda run -n $(ENV_NAME) flake8 src tests
	@echo "Running pylint..."
	@conda run -n $(ENV_NAME) pylint src tests

test:
	@echo "Running tests with pytest..."
	@conda run -n $(ENV_NAME) pytest tests