#!/bin/sh

# create directory skeleton
mkdir -p ${HOME}/.minetest/worlds/world/worldmods/

# clone dependencies
cd ${HOME}/.minetest/worlds/world/worldmods/
for dep in ${INPUT_DEPENDENCIES}
do
    git clone $dep
done

# create link to current mod
ln -s /github/workspace ${HOME}/.minetest/worlds/world/worldmods/${INPUT_MODNAME}

# assemble minetest.conf
cat <<EOF > /minetest.conf
default_game = minetest_game
mg_name = singlenode
mtt_filter = ${INPUT_MODNAME}
mtt_enable = true
EOF
echo "${INPUT_ADDITIONAL_CONFIG}" >> /minetest.conf

# simple world.mt
cat <<EOF > ${HOME}/.minetest/worlds/world/world.mt
enable_damage = false
creative_mode = true
mod_storage_backend = sqlite3
auth_backend = sqlite3
player_backend = dummy
backend = dummy
gameid = minetest
world_name = mtt
EOF

# start the engine
minetestserver --config /minetest.conf