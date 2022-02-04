.DEFAULT_GOAL := help

up: ## Runs MySQL container in the background
	docker-compose up -d
logs: ## View logs
	docker-compose logs -f
down: ## Brings MySQL container down
	docker-compose down


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ./Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
