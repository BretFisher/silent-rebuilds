FROM node:24.11@sha256:9a2ed90cd91b1f3412affe080b62e69b057ba8661d9844e143a6bbd76a23260f

RUN apt-get update && \
	apt-get dist-upgrade -y && \
	apt-get upgrade -y && \
	rm -rf /var/lib/apt/lists/*

