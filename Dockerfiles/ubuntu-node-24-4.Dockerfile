FROM ubuntu:24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get install -y curl gnupg && \
	curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
	apt-get install -y nodejs && \
	apt-get remove -y curl gnupg && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
