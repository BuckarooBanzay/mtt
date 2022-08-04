local test_index = 1

local function worker()
  local test = mtt.tests[test_index]
  if not test then
    -- exit gracefully
    minetest.request_shutdown("success")
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
    test_index = test_index + 1
    minetest.after(0, worker)
  end)
end

-- wait until all mods are loaded
minetest.register_on_mods_loaded(function()
    -- kick off testing after world is ready and settled
    minetest.after(1, worker)
end)