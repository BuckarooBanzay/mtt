
local benchmarks = {}

function mtt.benchmark(name, fn)
    table.insert(benchmarks, {
        name = name,
        fn = fn
    })
end

local function worker(index, success_callback)
    local entry = benchmarks[index]
    if not entry then
        success_callback()
        return
    end

    -- TODO
    minetest.after(1, worker, index+1, success_callback)
end

function mtt.run_benchmarks(success_callback)
    minetest.after(1, worker, 1, success_callback)
end