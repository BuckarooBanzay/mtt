local players = {}

-- merged "real" and "fake" player list
local old_get_connected_players = minetest.get_connected_players
function minetest.get_connected_players()
    local list = {}
    for _, p in pairs(players) do
        table.insert(list, p)
    end
    for _, p in ipairs(old_get_connected_players()) do
        table.insert(list, p)
    end
    return list
end

local old_get_player_information = minetest.get_player_information
function minetest.get_player_information(name)
    if players[name] then
        return players[name].info
    else
        return old_get_player_information(name)
    end
end

local old_get_player_by_name = minetest.get_player_by_name
function minetest.get_player_by_name(name)
    if players[name] then
        return players[name]
    else
        return old_get_player_by_name(name)
    end
end

function mtt.join_player(name)
    local player = fakelib.create_player({ name = name })
    players[name] = player

    local auth_handler = minetest.get_auth_handler()
    local auth = auth_handler.get_auth(name)
    if not auth then
        auth_handler.create_auth(name, "pass")
    end

    for _, fn in ipairs(minetest.registered_on_prejoinplayers) do
        fn(name, "127.0.0.1")
    end

    for _, fn in ipairs(minetest.registered_on_joinplayers) do
        fn(player)
    end

    -- get_player_information info
    player.info = {
        formspec_version = 4
    }

    -- custom leave function
    player.leave = function(timed_out)
        for _, fn in ipairs(minetest.registered_on_leaveplayers) do
            fn(player, timed_out)
        end
        players[name] = nil
    end

    return player
end
