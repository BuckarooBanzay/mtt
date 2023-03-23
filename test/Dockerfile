ARG ENGINE_VERSION=5.6.1
FROM registry.gitlab.com/minetest/minetest/server:${ENGINE_VERSION}
USER root

RUN apk add --no-cache lua-dev luarocks &&\
    luarocks-5.1 install luacov

ENTRYPOINT minetestserver --config /minetest.conf