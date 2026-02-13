FROM node:24.12@sha256:b52a8d1206132b36d60e51e413d9a81336e8a0206d3b648cabd6d5a49c4c0f54

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get upgrade -y && \
	rm -rf /var/lib/apt/lists/*

