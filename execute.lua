
local function shutdown()
    minetest.request_shutdown("success")
    if mtt.luacov_runner then
        mtt.luacov_runner.save_stats()
    end
end

-- wait until all mods are loaded
minetest.register_on_mods_loaded(function()
    -- kick off testing after world is ready and settled
    mtt.execute_tests(function()

        if mtt.enable_benchmarks then
            -- execute benchmarks
            mtt.execute_benchmarks(shutdown)
        else
            -- exit gracefully
            shutdown()
        end
    end)
end)