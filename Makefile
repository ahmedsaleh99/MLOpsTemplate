# Makefile

ENV_NAME = classroom-digital-twin
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
	@echo "Formatting code with Ruff..."
    @conda run -n $(ENV_NAME) ruff format
    @echo "Linting code With Ruff ..."
    @conda run -n $(ENV_NAME) ruff check  --fix
    

test:
	@echo "Checking Formatting & Linting with Ruff..."
	@conda run -n $(ENV_NAME) ruff check
    @echo "Running tests with pytest..."
    @conda run -n $(ENV_NAME) pytest tests