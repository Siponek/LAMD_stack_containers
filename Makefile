DIRNAME=$(shell basename ${PWD})
CURDIR=$(shell echo ${PWD})
DRUPAL_VER=9.4.8

.PHONY: up
up: build
	docker compose up

.PHONY: down
down:
	docker compose down
	rm -f ./config/settings.php

.PHONY: build
build:
	docker compose build

.PHONY: backup
backup:
	docker run --rm --network $(DIRNAME)_intnet -v $(CURDIR)/config:/config -v /tmp/:/backup drupal:$(DRUPAL_VER) backup
