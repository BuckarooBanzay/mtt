# mtt

Minetest test framework

Provides an api to register test functions for integration-tests.

Status: **Stable**

![](https://github.com/BuckarooBanzay/mtt/workflows/luacheck/badge.svg)
![](https://github.com/BuckarooBanzay/mtt/workflows/test/badge.svg)
[![License](https://img.shields.io/badge/License-MIT%20and%20CC%20BY--SA%203.0-green.svg)](license.txt)
[![Download](https://img.shields.io/badge/Download-ContentDB-blue.svg)](https://content.minetest.net/packages/BuckarooBanzay/mtt)

# Api

Main api:
```lua
-- simple test function with assert and success callback
mtt.register("my function name", function(callback)
    assert(my_condition == true)
    callback()
end)

-- test function with error message callback
mtt.register("my function name", function(callback)
    if not check_something then
        callback("didn't work :(")
    end
    callback() -- everything ok
end)

-- alternatively, using error:
mtt.register("my function name", function(callback)
    if not check_something then
        error("didn't work :(")
    end
    callback() -- everything ok
end)
```

Helper functions:
```lua
-- emerge area for another test that follows
mtt.emerge_area({x=0,y=0,z=0}, {x=32,y=32,z=32})
```

# Executing

This mod is inert by default and only provides its api.

To actually enable the tests add the following in your minetest config:
```
mtt_enable = true
```

After starting the minetest engine with this setting the mod will run all tests
and shutdown with an exit code of `0` if everything executed successfully.

# Example

For a CI example with docker you can take a look at the code in this repository.

The important files:
* `docker-compose.yml` the compose file that starts the minetest engine with `docker-compose up`
* `.github/workflows/test.yml` the github workflow file with a version matrix
* `test/world.mt` the server config for the test-mod
* `test/mod/*` the test-mod that uses `mtt` (as example and validation in this case)

The whole testing can of course also be done without any docker tools.

# Related work

* https://github.com/S-S-X/mineunit unit test framework

# License

* Code: `MIT`