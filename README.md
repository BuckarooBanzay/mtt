# mtt

Minetest test framework

Provides an api to register test functions for integration-tests.

Status: **Stable**

![](https://github.com/BuckarooBanzay/mtt/workflows/luacheck/badge.svg)
![](https://github.com/BuckarooBanzay/mtt/workflows/test/badge.svg)
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
local player = mtt.join_player("singleplayer")
player:leave()
```

# Executing

This mod is inert by default and only provides its api.

To actually enable the tests add the following in your minetest config:
```
mtt_enable = true
```

After starting the minetest engine with this setting the mod will run all tests
and shutdown with an exit code of `0` if everything executed successfully.

## Filtering executed tests

Tests can be filtered with the `mtt_filter` setting.

For example:
```
mtt_filter = my_mod,my_other_mod
```

This will only execute tests from the mod `my_mod` and `my_other_mod`

# Example

For a CI example with docker you can take a look at the code from the `mtzip` mod:

Repository: https://github.com/BuckarooBanzay/mtzip

The important files:
* `mtt.lua` the tests, those could alternatively be inlined with the main code
* `docker-compose.yml` the compose file that starts the minetest engine with `docker-compose up`
* `.github/workflows/test.yml` the github workflow file with a version matrix
* `test/minetest.conf` the server config for the test-mod
* `test/Dockerfile` dockerfile that pulls in test-dependencies including the `mtt` mod from the `master` branch

The whole testing can of course also be done without any docker tools.

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