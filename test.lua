local modfilter = minetest.settings:get("mtt_filter")

local tests = {}

function mtt.register(name, fn)
    if not mtt.enabled then
        -- nothing to do here, move along
        return
    end

    local modname = minetest.get_current_modname() or "?"

    -- check modfilter and current modname
    if modfilter then
        local match = false
        for filter in string.gmatch(modfilter, '([^,]+)') do
            if filter == modname then
                match = true
                break
            end
        end

        if not match then
            -- ignore this test
            return
        end
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