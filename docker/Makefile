SHELL := /bin/bash

user_id?=$(shell id -u)
group_id?=$(shell id -g)

check:
ifeq (,$(wildcard $(shell pwd)/.env))
	$(error .env file does not exist! run make env first.)
endif
ifeq ($(shell whoami),$(user_name))
	$(error Cannot run docker in target.)
endif
	source .env

compose: check
	./generate-compose.bash

build: check
	docker compose build ros-dev

run: check
	xhost +local:root
	docker compose up ros-dev

stop: check
	docker compose down ros-dev

attach: check
	docker exec -it ros-dev /bin/bash

env:
	@echo "USER_ID=$(user_id)" > $(docker_folder).env
	@echo "GROUP_ID=$(group_id)" >> $(docker_folder).env
	@echo "Wrote environment variables to $(shell pwd)/.env"
