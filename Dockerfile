FROM registry.gitlab.com/minetest/minetest/server:5.6.1
USER root

RUN apk add --no-cache git
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh