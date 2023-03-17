DOCKER_COMPOSE_YML		= srcs/docker-compose.yml
DOCKER_DATA_DIR			= $(HOME)/data

DOMAIN				= "127.0.0.1 yichoi.42.fr"

all : run

run : $(DOCKER_DATA_DIR) $(DOMAIN)
	docker-compose -f $(DOCKER_COMPOSE_YML) build --no-cache
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d
up :
	docker-compose -f $(DOCKER_COMPOSE_YML) up -d

$(DOCKER_DATA_DIR) :
	mkdir -p $(DOCKER_DATA_DIR)/DB
	mkdir -p $(DOCKER_DATA_DIR)/WordPress

$(DOMAIN) :
	@if [ ! "$$(sudo grep $(DOMAIN) /etc/hosts)" ]; then sudo sh -c 'echo $(DOMAIN) >> /etc/hosts'; fi

clean :
	docker-compose -f $(DOCKER_COMPOSE_YML) down --volumes
	docker system prune -a
	sudo rm -rf $(DOCKER_DATA_DIR)

fclean : clean
	sudo sed -i s/$(DOMAIN)//g /etc/hosts

.PHONY: all run clean fclean

# prune : 시스템에서 더 이상 ㅎ사용되지 않는 모든 이미지 및 컨테이너를 삭제.
