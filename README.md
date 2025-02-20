# mtt

Minetest test framework

Provides an api to register test functions for integration-tests.

Status: **Stable**

![](https://github.com/BuckarooBanzay/mtt/workflows/luacheck/badge.svg)
![](https://github.com/BuckarooBanzay/mtt/workflows/test/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/BuckarooBanzay/mtt/badge.svg?branch=main)](https://coveralls.io/github/BuckarooBanzay/mtt?branch=main)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](license.txt)
[![Download](https://img.shields.io/badge/Download-ContentDB-blue.svg)](https://content.minetest.net/packages/BuckarooBanzay/mtt)

# Api

Main api:
```lua
-- simple test function with assert and success callback
mtt.register("my test", function(callback)
    assert(my_condition == true)
    callback()
end)

-- test function with error message callback
mtt.register("my test", function(callback)
    if not check_something then
        callback("didn't work :(")
    end
    callback() -- everything ok
end)

-- alternatively, using error:
mtt.register("my test", function(callback)
    if not check_something then
        error("didn't work :(")
    end
    callback() -- everything ok
end

-- test function with an area
mtt.register_with_area("emerged area test", {
    -- the desired area size
    size = { x=10, y=10, z=10 },
    -- optional, area will be emerged first if true
    emerged = true
}, function(pos1, pos2, callback)
    -- execute test on area here
    assert(pos2.x - pos1.x == 9)
    assert(pos2.y - pos1.y == 9)
    assert(pos2.z - pos1.z == 9)
    callback()
end)

-- test definition table with timeout (optional)
mtt.register("my long test", {
  -- timeout defaults to 10 seconds unless manually specified
  timeout = 5,
  -- main test function
  func = function(callback)
    -- TODO: test things here
  end
})
```

Helper functions:
```lua
-- emerge area for another test that follows
mtt.emerge_area({x=0,y=0,z=0}, {x=32,y=32,z=32})

-- export all nodenames
local filename = minetest.get_worldpath() .. "/nodenames.txt"
mtt.export_nodenames(filename)

-- validate nodenames
mtt.validate_nodenames(minetest.get_modpath("my_mod") .. "/nodenames.txt")

-- simulate a player (EXPERIMENTAL, some methods aren't implemented yet)
-- NOTE: requires the `fakelib` mod to be present
local player = mtt.join_player("singleplayer")
-- TODO: use the player instance somewhere
-- let the player leave
mtt.leave_player("singleplayer")
```

# Executing

This mod is inert by default and only provides its api.

To actually enable the tests add the following in your minetest config:
```
mtt_enable = true
mtt_filter = my_mod,my_other_mod
```

After starting the minetest engine with this setting the mod will run all tests in the specified mod(s)
and shutdown with an exit code of `0` if everything executed successfully.

To ensure the tests are only registered if the `mtt` mod is present and enabled you might want to add the following check:
```lua
if minetest.get_modpath("mtt") and mtt.enabled then
 -- register tests here (directly or via dofile)
end
```

A complete example on how to add `mtt` for testing is available in the [mapsync](https://github.com/BuckarooBanzay/mapsync/blob/master/init.lua) mod

# Github action

The `mtt` tests can be used in a github runner:

A simple workflow for the mod `mymod`:
```yml
name: test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: buckaroobanzay/mtt@main
      with:
        modname: mymod
```

An [extended setup](https://github.com/mt-mods/promise/blob/master/.github/workflows/test.yml) with dependencies, coverage and additional minetest settings:
```yml
name: test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: buckaroobanzay/mtt@main
      with:
        modname: promise
        enable_coverage: "true"
        git_dependencies: |
          https://github.com/BuckarooBanzay/mtt
        additional_config: |
          secure.http_mods = promise
    - uses: coverallsapp/github-action@v1
```

All parameters:
* `modname` the name of the mod, defaults to the repository-name
* `mtt_filter` custom mods to filter for tests (`modname` is used if this is not set)
* `enable_coverage` enables coverage stats
* `enable_benchmarks` enables the benchmarks
* `git_dependencies` list of dependencies (git repositories)
* `additional_config` additional lines in the minetest.conf
* `git_game_repo` url to the game (defaults to the minetest_game)
* `test_mode` either 'mod' if the repository is a mod or 'game'
* `mapgen` the mapgen t use (default so singlenode)

# Running with plain docker

To use this with standalone docker you can use the provided docker image:
```sh
docker run --rm -it -v $(pwd):/github/workspace \
    -e INPUT_MODNAME=promise \
    -e INPUT_TEST_MODE=mod \
    -e INPUT_MAPGEN=singlenode \
    -e INPUT_GIT_GAME_REPO=https://github.com/minetest/minetest_game \
    ghcr.io/buckaroobanzay/mtt
```

The above example uses `promise` as mtt-filter, `singlenode` as mapgen and the default mtg as game.

# Related work

* https://github.com/S-S-X/mineunit unit test framework

# Used by

* https://github.com/BuckarooBanzay/mapblock_lib
* https://github.com/BuckarooBanzay/mapblock_tileset
* https://github.com/BuckarooBanzay/mtzip
* https://github.com/BuckarooBanzay/eco
* https://github.com/BuckarooBanzay/super_sam
* https://github.com/blockexchange/blockexchange
* https://github.com/mt-mods/mail

# License

* Code: `MIT`
