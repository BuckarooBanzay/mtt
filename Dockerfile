FROM registry.gitlab.com/minetest/minetest/server:5.6.0
USER root

RUN apk add --no-cache git &&\
    mkdir -p /root/.minetest/worlds/world/worldmods/ &&\
    git clone https://github.com/BuckarooBanzay/mtt /root/.minetest/worlds/world/worldmods/mtt

ENTRYPOINT minetestserver --config /minetest.conf