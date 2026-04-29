.PHONY: lint help setup hindsight-start hindsight-stop hindsight-logs hindsight-migrate

ANSIBLE_PLAYBOOKS := install.yml provision.yml

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install pre-commit hooks
	pre-commit install

lint: ## Run ansible-lint on all playbooks and roles
	ansible-lint $(ANSIBLE_PLAYBOOKS) roles/

hindsight-start: ## Start Hindsight via Docker
	docker run -d --name hindsight \
		-p 8888:8888 -p 9999:9999 \
		--env-file .env \
		-e HINDSIGHT_API_LLM_PROVIDER=gemini \
		-e HINDSIGHT_API_LLM_API_KEY=${GEMINI_API_KEY} \
		-v hindsight-data:/home/hindsight/.pg0 \
		--restart unless-stopped \
		ghcr.io/vectorize-io/hindsight:latest

hindsight-stop: ## Stop Hindsight
	docker stop hindsight && docker rm hindsight

hindsight-logs: ## View Hindsight logs
	docker logs -f hindsight

hindsight-migrate: ## Migrate .agent/ memories to Hindsight
	python scripts/migrate-to-hindsight.py
