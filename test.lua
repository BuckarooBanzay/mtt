local modfilter = minetest.settings:get("mtt_filter")

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
    test.fn(function(err)
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
    end)
end

function mtt.execute_tests(success_callback)
minetest.after(0, worker, 1, success_callback)
end