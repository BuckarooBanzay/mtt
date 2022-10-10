
mtt = {
    -- tests table
    tests = {},

    -- enabled flag
    enabled = minetest.settings:get("mtt_enable") == "true",

    -- export all nodenames to the worldpath (nodenames.txt)
    export_nodenames = minetest.settings:get("mtt_export_nodenames") == "true"
}

local MP = minetest.get_modpath("mtt")
dofile(MP .. "/api.lua")
dofile(MP .. "/util.lua")

if mtt.export_nodenames then
    dofile(MP .. "/export_nodenames.lua")
end

if mtt.enabled then
    minetest.log("warning", "mtt-mod active, don't enable this on a live-server!")

    -- player api override
    dofile(MP .. "/player.lua")

    -- start test execution
    dofile(MP .. "/execute.lua")
end
