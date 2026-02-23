.PHONY: lint help setup

ANSIBLE_PLAYBOOKS := install.yml provision.yml

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install pre-commit hooks
	pre-commit install

lint: ## Run ansible-lint on all playbooks and roles
	ansible-lint $(ANSIBLE_PLAYBOOKS) roles/
