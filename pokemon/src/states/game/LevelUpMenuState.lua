LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState, TakeTurnState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]
    local HPIncrease, attackIncrease, defenseIncrease, speedIncrease = self.playerPokemon:levelUp()

    self.levelUpMenu = Menu {
        x = (VIRTUAL_WIDTH / 2) - 64,
        y = 64,
        width = VIRTUAL_WIDTH / 2,
        height = 128,
        items = {
            {
                text = 'HP: ' .. tostring(self.playerPokemon.HP) .. ' + ' .. tostring(HPIncrease) .. ' = ' .. tostring(self.playerPokemon.HP + HPIncrease)
            },
            {
                text = 'Attack: ' .. tostring(self.playerPokemon.attack) .. ' + ' .. tostring(attackIncrease) .. ' = ' .. tostring(self.playerPokemon.attack + attackIncrease)
            },
            {
              text = 'Defense: ' .. tostring(self.playerPokemon.defense) .. ' + ' .. tostring(defenseIncrease) .. ' = ' .. tostring(self.playerPokemon.defense + defenseIncrease)
            },
            {
              text = 'Speed: ' .. tostring(self.playerPokemon.speed) .. ' + ' .. tostring(speedIncrease) .. ' = ' .. tostring(self.playerPokemon.speed + speedIncrease)
            }
        },
        hasCursor = false
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
      gStateStack:pop()
      TakeTurnState:fadeOutWhite()
      gSounds['blip']:stop()
      gSounds['blip']:play()
  end
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end