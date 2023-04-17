local tests = {}

function mtt.register(name, fn)
    assert(type(name) == "string")
    assert(type(fn) == "function")

    local modname = minetest.get_current_modname() or "?"
    if not mtt.is_mod_enabled(modname) then
        return
    end

    table.insert(tests, {
        name = name,
        modname = modname,
        fn = fn
    })
end

local function worker(index, success_callback)
    local test = tests[index]
    if not test then
        success_callback()
        return
    end

    local t_start = minetest.get_us_time()
    local result_handler = function(err)
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

    local p = test.fn(result_handler)
    if p and p.is_promise then
        -- promise returned, handle it
        p:next(result_handler)
        p:catch(function(err)
            -- ensure that the "err" param is set
            err = err or "unknown"
            result_handler(err)
        end)
    end
end

function mtt.execute_tests(success_callback)
    minetest.after(0, worker, 1, success_callback)
end