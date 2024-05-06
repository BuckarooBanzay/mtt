

local function no_op() end

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
    local pos = {x=0, y=0, z=0}
    local hud_flags = {}
    local armor_groups = {}
    local health = 20
    local breath = 20
    local properties = {
        eye_height = {x=0, y=0.8, z=0}
    }

    local player = {
        info = {
            formspec_version = 4
        },
        get_player_name = function() return name end,
        set_lighting = no_op,
        set_inventory_formspec = no_op,
        get_properties = function() return properties end,
        set_properties = function(p)
            for k, v in pairs(p) do
                properties[k] = v
            end
        end,
        set_local_animation = no_op,
        set_animation = no_op,
        set_formspec_prepend = no_op,
        get_inventory = function()
            local inv = minetest.get_inventory({type="detached", name=name})
            if not inv then
                inv = minetest.create_detached_inventory(name, {})
            end
            return inv
        end,
        hud_set_hotbar_image = no_op,
        hud_set_hotbar_selected_image = no_op,
        hud_get_flags = function() return hud_flags end,
        hud_set_flags = function(f) hud_flags = f end,
        get_armor_groups = function() return armor_groups end,
        set_armor_groups = function(g) armor_groups = g end,
        get_pos = function() return pos end,
        set_pos = function(p) pos = p end,
        get_health = function() return health end,
        set_health = function(h) health = h end,
        get_breath = function() return breath end,
        set_breath = function(b) breath = b end,
        leave = function(self, timed_out)
            for _, fn in ipairs(minetest.registered_on_leaveplayers) do
                fn(self, timed_out)
            end
            players[name] = nil
        end
    }

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

    return player
end