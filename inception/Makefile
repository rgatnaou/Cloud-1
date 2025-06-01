up: mkdir
	docker compose -f srcs/docker-compose.yml up  --build 

down:
	docker compose -f srcs/docker-compose.yml down 

clean: down
	docker volume rm DB Wordpress
	sudo rm -rf /home/rgatnaou/data

mkdir: 
	mkdir -p /home/rgatnaou/data/DB
	mkdir -p /home/rgatnaou/data/Wordpress
	
rm:down
	sudo rm -rf /home/rgatnaou/data/DB/*
	sudo rm -rf /home/rgatnaou/data/Wordpress/*
re: rm up