FROM node:24.11-alpine@sha256:682368d8253e0c3364b803956085c456a612d738bd635926d73fa24db3ce53d7

RUN apk update && \
	apk upgrade --no-cache
