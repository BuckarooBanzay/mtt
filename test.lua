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

    local modname = minetest.get_current_modname() or "?"
    if not mtt.is_mod_enabled(modname) then
        return
    end

    test_def.name = name
    test_def.modname = modname

    -- add test to table
    table.insert(tests, test_def)
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
    local t_start = minetest.get_us_time()
    local result_handler = function(err)
        -- mark finished
        has_finished = true

        -- delta time in microseconds
        local t_diff = math.floor((minetest.get_us_time() - t_start) / 100) / 10

        if err then
            -- error callback
            error("test failed: '" .. test.name .. "' with error: '" .. err .. "'")
        end
        print(
            "[mtt] Test executed (" .. t_diff .. " ms)" ..
            " mod: '" .. test.modname .. "'" ..
            " name: '" .. test.name .. "'"
        )

        -- schedule next test
        minetest.after(0, worker, index+1, success_callback)
    end

    -- timeout callback
    minetest.after(test.timeout, function()
        if not has_finished then
            local msg = "test failed: '" .. test.name .. "' due to timeout"
            minetest.log("error", msg)
            error(msg)
        end
    end)

    local p = test.func(result_handler)
    if p and p.is_promise then
        -- promise returned, handle it
        p:next(result_handler, function(err)
            -- ensure that the "err" param is set
            err = err or "<unknown>"
            -- log to stderr
            minetest.log("error", "test failed: '" .. test.name .. "' with error: '" .. err .. "'")
            -- force shutdown (can't use error() here, still in a pcall)
            minetest.after(0, function()
                error(err)
            end)
        end)
    end
end

function mtt.execute_tests(success_callback)
    minetest.after(0, worker, 1, success_callback)
end