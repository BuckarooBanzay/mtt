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

local player_infos = {}

local old_get_player_information = minetest.get_player_information
function minetest.get_player_information(name)
    if players[name] then
        return player_infos[name]
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
    print("[mtt] creating and joining fake player: " .. name)
    local player = fakelib.create_player({ name = name })
    players[name] = player

    local auth_handler = minetest.get_auth_handler()
    local auth = auth_handler.get_auth(name)
    if not auth then
        auth_handler.create_auth(name, "pass")
    end

    -- get_player_information info
    player_infos[name] = {
        formspec_version = 4
    }

    -- run prejoin callbacks
    for _, fn in ipairs(minetest.registered_on_prejoinplayers) do
        fn(name, "127.0.0.1")
    end

    -- run join callbacks
    for _, fn in ipairs(minetest.registered_on_joinplayers) do
        fn(player)
    end

    return player
end

function mtt.leave_player(name, timed_out)
    if not players[name] then
        return false
    end

    for _, fn in ipairs(minetest.registered_on_leaveplayers) do
        fn(players[name], timed_out)
    end

    players[name] = nil
    player_infos[name] = nil
    return true
end