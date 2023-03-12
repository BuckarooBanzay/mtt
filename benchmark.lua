
local benchmarks = {}

function mtt.benchmark(name, fn)
    assert(type(name) == "string")
    assert(type(fn) == "function")

    local modname = minetest.get_current_modname() or "?"
    if not mtt.is_mod_enabled(modname) then
        return
    end

    table.insert(benchmarks, {
        name = name,
        modname = modname,
        fn = fn
    })
end

local default_iterations = {1, 10, 100, 1000, 10000, 100000}

-- max execution-time, if this is reached the next iteration-counts are skipped
local max_time_micros = 100000

local function worker(index, success_callback)
    local entry = benchmarks[index]
    if not entry then
        success_callback()
        return
    end

    local it_index = 1

    local function iteration_worker()
        local iterations = default_iterations[it_index]
        if not iterations then
            -- all iterations done, next benchmark
            minetest.after(1, worker, index+1, success_callback)
            return
        end

        local t_start = minetest.get_us_time()

        local callback = function()
            local t_diff = minetest.get_us_time() - t_start
            if t_diff > max_time_micros then
                -- took too much time, skip further iterations
                it_index = -1
            else
                -- next iteration-count
                it_index = it_index + 1
            end

            print("[mtt] Benchmark '" .. entry.name ..
                "' in mod '" .. entry.modname ..
                "' with " .. iterations ..
                " iterations took " .. t_diff .. " microseconds")

            minetest.after(0, iteration_worker)
        end

        entry.fn(callback, iterations)
    end

    iteration_worker()
end

function mtt.execute_benchmarks(success_callback)
    minetest.after(1, worker, 1, success_callback)
end