FROM ghcr.io/minetest/minetest:5.10.0
USER root

RUN apk add --no-cache bash git lua-dev luarocks &&\
    luarocks-5.1 install luacov &&\
    luarocks-5.1 install luacov-reporter-lcov

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
