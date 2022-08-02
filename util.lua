
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

function mtt.export_nodenames(filename)
    local f = io.open(filename, "w")
    for nodename in pairs(minetest.registered_nodes) do
        f:write(nodename .. "\n")
    end
    f:close()
end

function mtt.validate_nodenames(filename)
    mtt.register("nodename_check", function(callback)
        local assert_nodes = {}
        for nodename in io.lines(filename) do
            table.insert(assert_nodes, nodename)
        end

        -- assemble node-list from registered lbm's
        local lbm_nodes = {}
        for _, lbm in ipairs(minetest.registered_lbms) do
            if type(lbm.nodenames) == "string" then
                -- duh, list as string
                lbm_nodes[lbm.nodenames] = true
            else
                -- proper list, add all regardless if they are a "group:*"
                for _, nodename in ipairs(lbm.nodenames) do
                    lbm_nodes[nodename] = true
                end
            end
        end

        -- check nodes
        local all_nodes_present = true
        for _, nodename in ipairs(assert_nodes) do
            if not minetest.registered_nodes[nodename]
                and not minetest.registered_aliases[nodename]
                and not lbm_nodes[nodename] then
                    error("Node not present and not available in an alias/lbm: " .. nodename)
            end
        end

        if not all_nodes_present then
            error("some of the required nodes are not present and not aliased!")
        end

        callback()
    end)
end