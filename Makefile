# Makefile

ENV_NAME = your_env_name
DEP_FILE = requirements.yaml
DEV_FILE = requirements-dev.yaml

.PHONY: prod-env  dev-env dev-depend format test


prod-env:
	@echo "Removing conda environment $(ENV_NAME) if exists..."
	@conda env remove -n $(ENV_NAME) -y --quiet || echo "Environment $(ENV_NAME) does not exist."
	@echo "Creating conda environment with name $(ENV_NAME)..."
	@conda env create -n $(ENV_NAME) --file $(DEP_FILE) -q
	@echo "Environment '$(ENV_NAME)' created successfully!"
	@echo "To activate, run: conda activate $(ENV_NAME)"

dev-depend:
	@echo "Installing development dependencies into '$(ENV_NAME)' from $(DEV_FILE)..."
	@conda env update -n $(ENV_NAME) --file $(DEV_FILE) -q
	@echo "Development dependencies installed!"
	@echo "Installing pre-commit"
	@conda run -n $(ENV_NAME) pre-commit install

dev-env: prod-env dev-depend

format:
	@echo "Formatting code with Ruff..."
	@conda run -n $(ENV_NAME) ruff format
	@echo "Linting code With Ruff ..."
	@conda run -n $(ENV_NAME) ruff check  --fix
	

test:
	@echo "Checking Formatting & Linting with Ruff..."
	@conda run -n $(ENV_NAME) ruff check
	@echo "Running tests with pytest..."
	@conda run -n $(ENV_NAME) pytest tests
