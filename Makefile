USER_ID = $(shell id -u)
GROUP_ID = $(shell id -g)
PROJECT=$(shell basename $(PWD))

dev:
	USER_ID=$(USER_ID) GROUP_ID=$(GROUP_ID) docker compose -f docker-compose.dev.yml -p $(PROJECT)-dev up

dev-build:
	USER_ID=$(USER_ID) GROUP_ID=$(GROUP_ID) docker compose -f docker-compose.dev.yml -p $(PROJECT)-dev up --build

dev-exec:
	docker compose -p $(PROJECT)-dev exec app sh

dev-local:
	build_postgres-15 || exit 0
	./bin/rails server
one:
	make down
	docker volume rm $(PROJECT)-one_postgres-data || exit 0
	docker compose -f docker-compose.one.yml -p $(PROJECT)-one up

one-build:
	make down
	docker volume rm $(PROJECT)-one_postgres-data || exit 0
	docker compose -f docker-compose.one.yml -p $(PROJECT)-one up --build

two:
	make down
	docker volume rm $(PROJECT)-two_postgres-data || exit 0
	docker compose -f docker-compose.two.yml -p $(PROJECT)-two up

two-build:
	make down
	docker volume rm $(PROJECT)-two_postgres-data || exit 0
	docker compose -f docker-compose.two.yml -p $(PROJECT)-two up --build

down:
	docker stop postgres-15 || exit 0
	docker stop postgres-11 || exit 0
	docker stop postgres || exit 0
	docker compose -p $(PROJECT)-dev down
	docker compose -p $(PROJECT)-one down
	docker compose -p $(PROJECT)-two down
