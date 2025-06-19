up: mkdir
	docker compose -f srcs/docker-compose.yml up  --build 

down:
	docker compose -f srcs/docker-compose.yml down 

clean: down
	docker volume rm DB Wordpress
	sudo rm -rf srcs/data

mkdir: 
	mkdir -p srcs/data/DB
	mkdir -p srcs/data/Wordpress
	
rm:down
	sudo rm -rf srcs/data/DB/*
	sudo rm -rf srcs/data/Wordpress/*
re: rm up