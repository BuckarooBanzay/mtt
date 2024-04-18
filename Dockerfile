FROM registry.gitlab.com/minetest/minetest/server:5.6.1
USER root

RUN apk add --no-cache git &&\
    mkdir -p /root/.minetest/worlds/world/worldmods/ &&\
    git clone https://github.com/BuckarooBanzay/mtt /root/.minetest/worlds/world/worldmods/mtt

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh