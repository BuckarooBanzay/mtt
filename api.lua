local modfilter = minetest.settings:get("mtt_filter")

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

    table.insert(mtt.tests, {
        name = name,
        modname = modname,
        fn = fn
    })
end