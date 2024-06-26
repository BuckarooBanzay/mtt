
mtt = {
    -- enabled flag
    enabled = minetest.settings:get("mtt_enable") == "true",

    -- benchmarks enabled flag
    enable_benchmarks = minetest.settings:get("mtt_enable_benchmarks") == "true",

    -- export all nodenames to the worldpath (nodenames.txt)
    export_nodenames = minetest.settings:get("mtt_export_nodenames") == "true",

    -- enable coverage with "luacov"
    -- requires `mtt` to be in the "secure.trusted_mods setting" and `luacov` to be installed
    -- warning: insecure vars are never cleaned up
    enable_coverage = minetest.settings:get("mtt_enable_coverage") == "true",

    -- enable self-tests
    enable_selftest = minetest.settings:get("mtt_enable_selftest") == "true",
}

local MP = minetest.get_modpath("mtt")
dofile(MP .. "/test.lua")
dofile(MP .. "/benchmark.lua")
dofile(MP .. "/util.lua")

if mtt.export_nodenames then
    dofile(MP .. "/export_nodenames.lua")
end

if mtt.enabled then
    minetest.log("warning", "[mtt] mod active, don't enable this on a live-server!")

    if mtt.enable_coverage then
        -- enable coverage
        local ie = minetest.request_insecure_environment and minetest.request_insecure_environment()
        loadfile(MP .. "/coverage.lua")(ie)
    end

    if minetest.get_modpath("fakelib") then
        -- player api override
        dofile(MP .. "/player.lua")
    end

    -- start test execution
    dofile(MP .. "/execute.lua")

    if mtt.enable_selftest then
        dofile(MP .. "/selftest.lua")
    end
end
