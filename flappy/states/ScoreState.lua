--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

thirdPlace = love.graphics.newImage('thirdplace.png')
secondPlace = love.graphics.newImage('secondplace.png')
firstPlace = love.graphics.newImage('firstplace.png')

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen

    if self.score >= 1 and self.score < 5 then
        love.graphics.draw(thirdPlace, 0, 64, 0, 0.25, 0.25)
        love.graphics.printf('Oof! You got a bronze medal, keep trying!', 0, 64, VIRTUAL_WIDTH, 'center')

    elseif self.score >= 5 and self.score < 10 then
        love.graphics.draw(secondPlace, 0, 64, 0, 0.25, 0.25)
        love.graphics.printf('Oof! You got a silver medal, keep going!', 0, 64, VIRTUAL_WIDTH, 'center')
    
    elseif self.score >= 10 then
        love.graphics.draw(firstPlace, 0, 64, 0, 0.25, 0.25)
        love.graphics.printf('WoW! You got a Gold medal, Let\'s go!', 0, 64, VIRTUAL_WIDTH, 'center')
    
    else
        love.graphics.setFont(flappyFont)
        love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end