COMPOSE = docker compose -f src/docker-compose.yaml

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart:
	$(COMPOSE) down
	$(COMPOSE) up -d

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v --remove-orphans
	docker system prune -f
	sudo rm -rf /home/razaccar/data/wordpress
	sudo rm -rf /home/razaccar/data/mariadb
	sudo mkdir -p /home/razaccar/data/wordpress
	sudo mkdir -p /home/razaccar/data/mariadb

fclean: clean

re: clean all

.PHONY: all up down stop start restart clean fclean re pd
