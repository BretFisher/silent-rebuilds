FROM node:24.4-alpine

RUN apk update && \
	apk upgrade --no-cache
