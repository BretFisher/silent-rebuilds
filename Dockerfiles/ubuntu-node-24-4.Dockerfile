FROM ubuntu:24.04

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y curl gnupg && \
	curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
	apt-get install -y nodejs && \
	apt-get remove -y curl gnupg && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
