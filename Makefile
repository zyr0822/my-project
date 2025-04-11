# Build configuration
# -------------------

APP_NAME := `sed -n 's/^ *name.*=.*"\([^"]*\)".*/\1/p' pyproject.toml`
APP_VERSION := `sed -n 's/^ *version.*=.*"\([^"]*\)".*/\1/p' pyproject.toml`
GIT_REVISION = `git rev-parse HEAD`

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo "\033[34mEnvironment\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@printf "\033[33m%-23s\033[0m" "APP_NAME"
	@printf "\033[35m%s\033[0m" $(APP_NAME)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "APP_VERSION"
	@printf "\033[35m%s\033[0m" $(APP_VERSION)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_REVISION"
	@printf "\033[35m%s\033[0m" $(GIT_REVISION)
	@echo "\n"

.PHONY: targets
targets:
	@echo "\033[34mDevelopment Targets\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# Development targets
# -------------

.PHONY: install
install: ## Install dependencies
	uv add pyproject.toml


.PHONY: run
run: start

.PHONY: start
start: ## Starts the server
	python run.py

# Check, lint and format targets
# ------------------------------

.PHONY: check
check: check-format lint

.PHONY: check-format
check-format: ## Dry-run code formatter
	black ./ --check
	isort ./ --profile black --check

.PHONY: lint
lint: ## Run ruff
	ruff check ./app 
 
.PHONY: format
format: ## Run code formatter
	black ./
	isort ./ --profile black


.PHONY: test
test: ## Run the test suite
	$(eval include .env)
	$(eval export $(sh sed 's/=.*//' .env))
	pytest -vv -s --cache-clear ./

.PHONY: clean-db
clean-db: ## 删除migrations文件夹和db.sqlite3
	find . -type d -name "migrations" -exec rm -rf {} +
	rm -f db.sqlite3 db.sqlite3-shm db.sqlite3-wal

.PHONY: migrate
migrate: ## 运行aerich migrate命令生成迁移文件
	aerich migrate

.PHONY: upgrade
upgrade: ## 运行aerich upgrade命令应用迁移
	aerich upgrade