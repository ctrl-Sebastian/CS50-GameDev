--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        canBeLifted = false,
        isConsumable = true
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        frames = POT_FRAMES,
        width = 16,
        height = 16,
        solid = true,
        canBeLifted = true,
        isConsumable = false,
        lifted = false
        }
    }
