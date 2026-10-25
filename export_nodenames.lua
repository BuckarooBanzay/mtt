
-- export all found nodenames to worldpath
core.register_on_mods_loaded(function()
    local filename = core.get_worldpath() .. "/nodenames.txt"
    print("[mtt] exporting all nodenames to '" .. filename .. "'")
    mtt.export_nodenames(filename)
end)