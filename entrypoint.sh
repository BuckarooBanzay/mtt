#!/bin/sh
set -e
export WORLDPATH=${HOME}/.minetest/worlds/world

# create directory skeleton
mkdir -p ${WORLDPATH}/worldmods/

# clone dependencies
cd ${WORLDPATH}/worldmods/
for dep in ${INPUT_GIT_DEPENDENCIES}
do
    git clone --depth=1 $dep
done

# install game
cd ${WORLDPATH}/
git clone --depth=1 ${INPUT_GIT_GAME_REPO} game

# create link to current mod
ln -s /github/workspace ${WORLDPATH}/worldmods/${INPUT_MODNAME}

# assemble minetest.conf
cat <<EOF > /minetest.conf
mg_name = ${INPUT_MAPGEN}
mtt_filter = ${INPUT_MODNAME}
mtt_enable = true
EOF
echo "${INPUT_ADDITIONAL_CONFIG}" >> /minetest.conf

# simple world.mt
cat <<EOF > ${WORLDPATH}/world.mt
enable_damage = false
creative_mode = true
mod_storage_backend = sqlite3
auth_backend = sqlite3
player_backend = dummy
backend = dummy
gameid = game
world_name = mtt
EOF

# start the engine
minetestserver --config /minetest.conf --world ${WORLDPATH}