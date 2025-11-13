FROM node:24.11@sha256:0c4b1219e836193f8ff099c43a36cb6ebf1bfe4a9a391e9f9eca5b4c96fae5b3

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get upgrade -y && \
	rm -rf /var/lib/apt/lists/*

