
-- wait until all mods are loaded
minetest.register_on_mods_loaded(function()
  -- kick off testing after world is ready and settled
  mtt.execute_tests(function()
    -- exit gracefully
    minetest.request_shutdown("success")
  end)
end)