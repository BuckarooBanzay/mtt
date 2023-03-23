ARG ENGINE_VERSION=5.6.1
FROM registry.gitlab.com/minetest/minetest/server:${ENGINE_VERSION}
USER root

RUN apk add --no-cache lua-dev luarocks alpine-sdk &&\
    luarocks-5.1 install luacov &&\
    luarocks-5.1 install luacov-coveralls

ENTRYPOINT minetestserver --config /minetest.conf && (test -n "${COVERALLS_REPO_TOKEN}" && luacov-coveralls -v || true)