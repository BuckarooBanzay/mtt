
mtt = {
    -- tests table
    tests = {},

    -- enabled flag
    enabled = minetest.settings:get("mtt_enable") == "true"
}

local MP = minetest.get_modpath("mtt")
dofile(MP .. "/api.lua")
dofile(MP .. "/util.lua")

if mtt.enabled then
    -- start test execution
    dofile(MP .. "/execute.lua")
end
