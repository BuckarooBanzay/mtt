local modfilter = minetest.settings:get("mtt_filter")

function mtt.register(name, fn)
    local modname = minetest.get_current_modname()

    if modfilter then
        local match = false
        for filter in string.gmatch(modfilter, '([^,]+)') do
            if filter == modname then
                match = true
                break
            end
        end

        if not match then
            -- ignore this job
            return
        end
    end

    table.insert(mtt.jobs, {
        name = name,
        modname = modname,
        fn = fn
    })
end