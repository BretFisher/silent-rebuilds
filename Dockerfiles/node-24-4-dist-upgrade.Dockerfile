FROM node:24.12@sha256:20988bcdc6dc76690023eb2505dd273bdeefddcd0bde4bfd1efe4ebf8707f747

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get upgrade -y && \
	rm -rf /var/lib/apt/lists/*

