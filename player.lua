
local function no_op() end

local players = {}

function minetest.get_connected_players()
    return players
end

function minetest.get_player_information()
    return {
        formspec_version = 4
    }
end

function mtt.join_player(name)
    local pos = {x=0, y=0, z=0}
    local properties = {
        eye_height = {x=0, y=0.8, z=0}
    }

    local player = {
        get_player_name = function() return name end,
        set_lighting = no_op,
        set_inventory_formspec = no_op,
        get_properties = function() return properties end,
        set_properties = function(p) properties = p end,
        set_local_animation = no_op,
        set_animation = no_op,
        set_formspec_prepend = no_op,
        hud_set_hotbar_image = no_op,
        hud_set_hotbar_selected_image = no_op,
        get_pos = function() return pos end,
        set_pos = function(p) pos = p end
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