FROM ghcr.io/minetest-hosting/minetest-docker:5.8.0
USER root

RUN apk add --no-cache git lua-dev luarocks &&\
    luarocks-5.1 install luacov &&\
    luarocks-5.1 install luacov-reporter-lcov

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh