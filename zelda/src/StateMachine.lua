StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		processAI = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName]) -- state must exist!
	self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end

--[[
	Used for states that can be controlled by the AI to influence update logic. By having this and
	not just bundling the decision-making into :update, we allow ourselves to reuse states between
	the player and agents in our game, rather than create a separate state for each (or at least
	allow the player to use the base state and then call its own inherited version of that state to
	save on code) See how PlayerWalkState calls EntityWalkState.update within :update for an example.
]]
function StateMachine:processAI(params, dt)
	self.current:processAI(params, dt)
end

--[[
	Error

src/StateMachine.lua:16: assertion failed!


Traceback

[love "callbacks.lua"]:228: in function 'handler'
[C]: in function 'assert'
src/StateMachine.lua:16: in function 'change'
src/Entity.lua:79: in function 'changeState'
src/states/entity/player/PlayerPotWalkState.lua:34: in function 'update'
src/StateMachine.lua:23: in function 'update'
src/Entity.lua:99: in function 'update'
src/Player.lua:16: in function 'update'
src/world/Room.lua:166: in function 'update'
src/world/Dungeon.lua:137: in function 'update'
src/states/game/PlayState.lua:48: in function 'update'
src/StateMachine.lua:23: in function 'update'
main.lua:51: in function 'update'
[love "callbacks.lua"]:162: in function <[love "callbacks.lua"]:144>
[C]: in function 'xpcall'
]]