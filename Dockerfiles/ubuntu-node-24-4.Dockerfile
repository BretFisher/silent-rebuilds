FROM ubuntu:24.10@sha256:cdf755952ed117f6126ff4e65810bf93767d4c38f5c7185b50ec1f1078b464cc

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y curl gnupg && \
	curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
	apt-get install -y nodejs && \
	apt-get remove -y curl gnupg && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
