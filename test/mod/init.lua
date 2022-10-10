
-- test emerge helper
mtt.emerge_area({x=0,y=0,z=0}, {x=32,y=32,z=32})

-- simple test function
mtt.register("my func", function(callback)
    assert(true)
    callback()
end)

mtt.register_with_area("area test", {
    size = { x=10, y=10, z=10 }
}, function(pos1, pos2, callback)
    assert(pos2.x - pos1.x == 9)
    assert(pos2.y - pos1.y == 9)
    assert(pos2.z - pos1.z == 9)
    callback()
end)

mtt.register_with_area("emerged area test", {
    size = { x=10, y=10, z=10 },
    emerged = true
}, function(pos1, pos2, callback)
    assert(pos2.x - pos1.x == 9)
    assert(pos2.y - pos1.y == 9)
    assert(pos2.z - pos1.z == 9)
    callback()
end)

-- nodename export and validation
local filename = minetest.get_worldpath() .. "/nodenames.txt"
mtt.export_nodenames(filename)
mtt.validate_nodenames(filename)

-- recipe check
mtt.check_recipes("dye")

-- player join/leave
mtt.register("player join", function(callback)
    local joined_obj
    minetest.register_on_joinplayer(function(o) joined_obj = o end)
    local p = mtt.join_player("test")
    assert(p)
    assert(joined_obj)
    callback()
end)