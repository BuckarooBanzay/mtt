FROM registry.gitlab.com/minetest/minetest/server:5.6.1
USER root

RUN apk add --no-cache git lua-dev luarocks &&\
    luarocks-5.1 install luacov &&\
    luarocks-5.1 install luacov-reporter-lcov

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh