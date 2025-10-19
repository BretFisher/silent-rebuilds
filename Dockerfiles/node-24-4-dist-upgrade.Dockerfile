FROM node:24.10

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get upgrade -y && \
	rm -rf /var/lib/apt/lists/*

