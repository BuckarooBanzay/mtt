
local function shutdown()
    core.request_shutdown("success")
    if mtt.luacov_runner then
        mtt.luacov_runner.save_stats()
        mtt.luacov_runner.run_report()
    end
end

-- wait until all mods are loaded
core.register_on_mods_loaded(function()
    -- kick off testing after world is ready and settled
    core.log("action", "[mtt] tests starting")
    mtt.execute_tests(function()

        if mtt.enable_benchmarks then
            -- execute benchmarks
            mtt.execute_benchmarks(shutdown)
        else
            -- exit gracefully
            core.log("action", "[mtt] tests done!")
            shutdown()
        end
    end)
end)