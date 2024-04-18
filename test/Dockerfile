ARG ENGINE_VERSION=master
FROM ghcr.io/minetest/minetest:${ENGINE_VERSION}
USER root

RUN apk add --no-cache lua-dev luarocks &&\
    luarocks-5.1 install luacov &&\
    luarocks-5.1 install luacov-reporter-lcov

RUN apk add --no-cache git &&\
    mkdir -p /root/.minetest/worlds/world/worldmods/ &&\
    git clone https://github.com/BuckarooBanzay/promise /root/.minetest/worlds/world/worldmods/promise

ENTRYPOINT minetestserver --config /minetest.conf