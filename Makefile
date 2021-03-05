domain := ""
server := ""
container := "www"

dc := docker-compose
de := docker-compose exec www
dr := $(dc) run --rm
sy := $(de) php bin/console
drtest := $(dc) -f docker-compose.test.yml run --rm
node := $(dr) node
php := $(dr) --no-deps php

.DEFAULT_GOAL := help
.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deploy
deploy: ## Déploie une nouvelle version du site
	ssh -A $(server) 'cd $(domain) && git pull origin master && make install'

.PHONY: install
install: vendor/autoload.php public/assets/manifest.json ## Installe les différentes dépendances
	APP_ENV=prod APP_DEBUG=0 $(php) composer install --no-dev --optimize-autoloader
	make migrate
	APP_ENV=prod APP_DEBUG=0 $(sy) cache:clear

.PHONY: seed
seed: vendor/autoload.php ## Génère des données dans la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:migrations:migrate -q
	$(sy) app:seed -q

.PHONY: migration
migration: vendor/autoload.php ## Génère les migrations
	$(sy) make:migration

.PHONY: migrate
migrate: vendor/autoload.php ## Migre la base de données (docker-compose up doit être lancé)
	$(sy) doctrine:migrations:migrate -q

.PHONY: test
test: vendor/autoload.php ## Execute les tests
	$(drtest) phptest vendor/bin/phpunit

build:
	$(MAKE) prepare-test
	$(MAKE) analyze
	$(MAKE) tests

unit-tests:
	$(de) bin/phpunit --testsuite unit

integration-tests:
	$(de )bin/phpunit --testsuite integration

system-tests:
	$(de) composer database-test
	$(de) bin/phpunit --testsuite system

e2e-tests:
	$(de) composer database-panther
	$(de) bin/phpunit --testsuite end_to_end

.PHONY: tests
tests:
	$(de) ../bin/phpunit ../tests

analyze:
	$(de) composer valid
	$(sy ) doctrine:schema:valid --skip-sync --env=test
	$(de ) php vendor/bin/phpcs
	$(de) php vendor/bin/phpstan -n analyze domain/src src

prepare-dev:
	$(de) composer install --prefer-dist
	$(sy) doctrine:database:drop --if-exists -f --env=dev
	$(sy) doctrine:database:create --env=dev
	$(sy) doctrine:schema:update -f --env=dev
	$(sy) doctrine:fixtures:load -n --env=dev

prepare-test:
	$(de) composer install --prefer-dist
	$(dy) cache:clear --env=test
	$(dy) doctrine:database:drop --if-exists -f --env=test
	$(dy) doctrine:database:create --env=test
	$(dy) doctrine:schema:update -f --env=test
	$(dy) doctrine:fixtures:load -n --env=test

integration:
	composer install --prefer-dist
	cp .env.integration .env.test
	php bin/console cache:clear --env=test
	php bin/console doctrine:database:drop --if-exists -f --env=test
	php bin/console doctrine:database:create --env=test
	php bin/console doctrine:schema:update -f --env=test
	php bin/console doctrine:fixtures:load -n --env=test