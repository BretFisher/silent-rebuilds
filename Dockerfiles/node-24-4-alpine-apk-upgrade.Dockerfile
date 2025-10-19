FROM node:24.10-alpine

RUN apk update && \
	apk upgrade --no-cache
