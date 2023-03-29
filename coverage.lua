local ie = ...
if ie then
    print("[mtt] coverage via luacov enabled")

    mtt.old_io = io
    require = ie.require
    io = ie.io
    mtt.luacov_runner = require("luacov.runner")

    local include_paths = {}
    for modname in pairs(mtt.get_enabled_mods()) do
        table.insert(include_paths, minetest.get_modpath(modname))
    end

    mtt.luacov_runner.init({
        include = include_paths,
        exclude = {
            ".+spec"
        },
        reporter = "lcov",
        reportfile = "lcov.info"
    })
end
