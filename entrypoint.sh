#!/bin/bash
set -e
export WORLDPATH=${HOME}/.minetest/worlds/world

# create directory skeleton
mkdir -p ${WORLDPATH}/worldmods/

# clone dependencies
cd ${WORLDPATH}/worldmods/
for dep in ${INPUT_GIT_DEPENDENCIES}
do
    git clone --recurse-submodules --depth=1 $dep
done

# add game or mod
cd ${WORLDPATH}/
if [ "${INPUT_TEST_MODE}" == "mod" ]
then
    # repository is a mod
    echo "testing-mode: mod"

    # determine modname
    modname=${GITHUB_REPOSITORY#*/}
    if [ ! -z "${INPUT_MODNAME}" ]
    then
        modname=${INPUT_MODNAME}
    fi

    # install game
    echo "Cloning ${INPUT_GIT_GAME_REPO} into game directory"
    git clone --recurse-submodules --depth=1 ${INPUT_GIT_GAME_REPO} game

    # create link to current mod
    ln -s /github/workspace ${WORLDPATH}/worldmods/${modname}
else
    # repository is a game
    echo "testing-mode: game"
    ln -s /github/workspace ${WORLDPATH}/game
fi

# add the mtt mod if it does not exist
if [ ! -d ${WORLDPATH}/worldmods/mtt ]
then
   git clone --depth=1 https://github.com/BuckarooBanzay/mtt ${WORLDPATH}/worldmods/mtt
fi

# check for "mtt_filter" var, use modname if not set
export mtt_filter=${modname}
if [ ! -z "${INPUT_MTT_FILTER}" ]
then
    mtt_filter=${INPUT_MTT_FILTER}
fi
echo "list of mods to test: ${mtt_filter}"

# assemble minetest.conf
cat <<EOF > /minetest.conf
mg_name = ${INPUT_MAPGEN}
mtt_filter = ${mtt_filter}
mtt_enable_coverage = ${INPUT_ENABLE_COVERAGE}
mtt_enable_benchmarks = ${INPUT_ENABLE_BENCHMARKS}
mtt_enable = true
secure.trusted_mods = mtt
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
luantiserver --config /minetest.conf --world ${WORLDPATH}

# coverage filename replace
if [ "${INPUT_ENABLE_COVERAGE}" == "true" ]
then
    for modname in $(echo ${mtt_filter} | tr ',' ' ')
    do
        sed -i "s#${WORLDPATH}/worldmods/${modname}/##g" ${WORLDPATH}/lcov.info
        sed -i "s#${WORLDPATH}/game/mods/${modname}/##g" ${WORLDPATH}/lcov.info
    done
    mkdir /github/workspace/coverage
    cp ${WORLDPATH}/lcov.info /github/workspace/coverage/
fi