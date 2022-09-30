
-- export all found nodenames to worldpath
minetest.register_on_mods_loaded(function()
    local filename = minetest.get_worldpath() .. "/nodenames.txt"
    print("[mtt] exporting all nodenames to '" .. filename .. "'")
    mtt.export_nodenames(filename)
end)