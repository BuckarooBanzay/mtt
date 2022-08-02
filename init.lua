
mtt = {
    -- test jobs table
    jobs = {}
}

local MP = minetest.get_modpath("mtt")
dofile(MP .. "/api.lua")
dofile(MP .. "/util.lua")

if minetest.settings:get("mtt_enable") == "true" then
    -- start test execution
    dofile(MP .. "/execute.lua")
end
