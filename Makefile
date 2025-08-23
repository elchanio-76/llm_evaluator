.PHONY: help setup test lint format clean docker-build docker-run deploy

SHELL := /bin/bash

# Detect OS for cross-platform compatibility
ifeq ($(OS),Windows_NT)
    PYTHON := python
    VENV_ACTIVATE := venv\Scripts\activate
    RM := rmdir /s /q
else
    PYTHON := python3
    VENV_ACTIVATE := source venv/bin/activate
    RM := rm -rf
endif

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Set up development environment
	$(PYTHON) -m venv venv
	$(VENV_ACTIVATE) && pip install --upgrade pip
	$(VENV_ACTIVATE) && pip install -r requirements-dev.txt
	$(VENV_ACTIVATE) && pre-commit install

test: ## Run tests
	$(VENV_ACTIVATE) && pytest tests/ -v --cov=src --cov-report=html

test-unit: ## Run unit tests only
	$(VENV_ACTIVATE) && pytest tests/unit/ -v

test-integration: ## Run integration tests only
	$(VENV_ACTIVATE) && pytest tests/integration/ -v

lint: ## Run linting
	$(VENV_ACTIVATE) && flake8 src tests
	$(VENV_ACTIVATE) && mypy src
	$(VENV_ACTIVATE) && bandit -r src

format: ## Format code
	$(VENV_ACTIVATE) && black src tests
	$(VENV_ACTIVATE) && isort src tests

clean: ## Clean up generated files
	$(RM) .pytest_cache
	$(RM) htmlcov
	$(RM) .coverage
	find . -type d -name __pycache__ -exec $(RM) {} +
	find . -type f -name "*.pyc" -delete

docker-build: ## Build Docker image
	docker build -f docker/Dockerfile.prod -t $(PROJECT_NAME):latest .

docker-run: ## Run Docker container locally
	docker-compose up

deploy-dev: ## Deploy to development environment
	./scripts/deploy.sh dev

deploy-prod: ## Deploy to production environment
	./scripts/deploy.sh prod

sagemaker-deploy: ## Deploy model to SageMaker
	$(VENV_ACTIVATE) && python scripts/deploy_sagemaker.py

lambda-deploy: ## Deploy Lambda function
	$(VENV_ACTIVATE) && python scripts/deploy_lambda.py
