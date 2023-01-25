include .env

build:
	make stop_services
	docker-compose -f docker-compose.yml build
	docker-compose -f docker-compose.yml up -d
	docker exec $(CONTAINER_PREFIX)_php composer install
	docker exec $(CONTAINER_PREFIX)_php php artisan key:generate
	docker exec $(CONTAINER_PREFIX)_php chmod 777 .env storage
	make up
	echo "Build complete"

up:
	make stop_services
	docker-compose -f docker-compose.yml up -d

stop:
	docker-compose -f docker-compose.yml stop
	make start_services

down:
	docker-compose -f docker-compose.yml down
	make start_services



bash:
	docker exec -it $(CONTAINER_PREFIX)_php /bin/bash

analyse:
	cd src && composer analyse 2>&1 | tee storage/logs/analyse.log

start_services:
	sudo service redis-server start || true
	sudo service db start || true
	sudo service nginx start || true

stop_services:
	sudo service redis-server stop || true
	sudo service db stop || true
	sudo service nginx stop || true

.PHONY: build up stop down ex analyse purge start_services stop_services
