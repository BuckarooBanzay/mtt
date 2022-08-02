
function mtt.emerge_area(pos1, pos2)
    mtt.register("emerge_area " .. minetest.pos_to_string(pos1) .. " -> " .. minetest.pos_to_string(pos2),
    function(callback)
        minetest.emerge_area(pos1, pos2, function(_, _, calls_remaining)
            if calls_remaining == 0 then
                callback()
            end
        end)
    end)
end