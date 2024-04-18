#!/bin/sh
export


mkdir -p ${HOME}/.minetest/worlds/world/worldmods/
cd ${HOME}/.minetest/worlds/world/worldmods/

for dep in ${INPUT_DEPENDENCIES}
do
    git clone $dep
done


ln -s /github/workspace ${HOME}/.minetest/worlds/world/worldmods/${INPUT_MODNAME}

cat <<EOF > /minetest.conf
default_game = minetest_game
mg_name = singlenode
mtt_filter = mtt
mtt_enable = true
mtt_enable_benchmarks = true
mtt_export_nodenames = true
mtt_enable_selftest = true
EOF

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

minetestserver --config /minetest.conf