local job_index = 1

local function worker()
  local job = mtt.jobs[job_index]
  if not job then
    -- exit gracefully
    minetest.request_shutdown("success")
    return
  end

  job.fn(function(err)
    if err then
        -- error callback
        error("test failed: '" .. job.name .. "' with error: '" .. err .. "'")
    end

    -- schedule next job
    job_index = job_index + 1
    minetest.after(0, worker)
  end)
end

-- wait until the world is ready
minetest.register_on_mods_loaded(function()
    minetest.after(1, function()
        -- kick off testing
        worker()
    end)
end)