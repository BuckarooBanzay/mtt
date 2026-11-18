local tests = {}

function mtt.register(name, fn_or_table)
    local test_def
    if type(fn_or_table) == "function" then
        test_def = {func = fn_or_table }
    elseif type(fn_or_table) == "table" then
        test_def = fn_or_table
    else
        error("table or function expected in test: '" .. name .. "'")
    end

    -- default to 10 seconds timeout
    test_def.timeout = test_def.timeout or 10

    assert(type(name) == "string", "test name is given")
    assert(type(test_def.func) == "function", "test function is present")

    local modname = core.get_current_modname() or "?"
    if not mtt.is_mod_enabled(modname) then
        return
    end

    test_def.name = name
    test_def.modname = modname

    -- add test to table
    table.insert(tests, test_def)
end

-- report a test failure and crash the server (non-zero exit code)
-- the error is raised in a fresh `core.after` callback so it can't be swallowed
-- by a pcall in the caller (promise handlers, mod callbacks, etc)
local function fail(msg)
    core.log("error", msg)
    core.after(0, function()
        error(msg, 0)
    end)
end

local function worker(index, success_callback)
    local test = tests[index]
    if not test then
        success_callback()
        return
    end

    -- finished marker for the timeout function
    local has_finished = false

    -- start time in microseconds
    local t_start = core.get_us_time()
    local result_handler = function(err)
        if has_finished then
            -- already reported (double callback or timeout)
            return
        end
        -- mark finished
        has_finished = true

        -- delta time in microseconds
        local t_diff = math.floor((core.get_us_time() - t_start) / 100) / 10

        if err then
            fail("test failed: '" .. test.name .. "' with error: '" .. tostring(err) .. "'")
            return
        end
        print(
            "[mtt] Test executed (" .. t_diff .. " ms)" ..
            " mod: '" .. test.modname .. "'" ..
            " name: '" .. test.name .. "'"
        )

        -- schedule next test
        core.after(0, worker, index+1, success_callback)
    end

    -- timeout callback
    core.after(test.timeout, function()
        if not has_finished then
            has_finished = true
            fail("test failed: '" .. test.name .. "' due to timeout")
        end
    end)

    local p = test.func(result_handler)
    if p and p.is_promise then
        -- promise returned, handle it
        p:next(function()
            -- ignore the resolved value, it is not an error
            result_handler()
        end, function(err)
            -- ensure that the "err" param is set
            result_handler(err or "<unknown>")
        end)
    end
end

function mtt.execute_tests(success_callback)
    core.after(0, worker, 1, success_callback)
end