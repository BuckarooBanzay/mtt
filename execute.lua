local test_index = 1

local function worker()
  local test = mtt.tests[test_index]
  if not test then
    -- exit gracefully
    minetest.request_shutdown("success")
    return
  end

  print("[mtt] Executing test, mod: '" .. test.modname .. "' name: '" .. test.name .. "'")
  test.fn(function(err)
    if err then
        -- error callback
        error("test failed: '" .. test.name .. "' with error: '" .. err .. "'")
    end

    -- schedule next test
    test_index = test_index + 1
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