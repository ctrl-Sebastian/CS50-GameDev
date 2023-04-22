--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}

    self.level = level
    self.colors = {
        2 * math.random(2), -- pinks
        2 * math.random(0,2) + 1, -- brown/green
        2 * math.random(0,1) + 6, -- reds
        2 * math.random(0,1) + 7, -- brighter greens
        2 * math.random(0,1) + 10, -- orange/brown
        2 * math.random(0,1) + 11, -- blues
        2 * math.random(0,2) + 14, -- greys
        2 * math.random(0,1) + 15 -- purples
    }

    self:initializeTiles(level)
end

function Board:initializeTiles(level)
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            --variety is equal to a random value between 0 and the minimum value between the current level and 6
            local variety = math.random(math.min(level, 6))
            -- create a new tile at X,Y with a random color and variety

                                                            --the color is going to be a random value
                                                            --between 0 and the quantity of colors in
                                                            --self.colors

            table.insert(self.tiles[tileY], Tile(tileX, tileY, self.colors[math.random(#self.colors)], variety))
        end
    end

    while self:calculateMatches() or not self:existsMatch() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles(level)
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    if self.tiles[y][x].isShiny == true then
                    end

                    local foundShiny = false
                    -- go backwards from here by matchNum and check if one of the tiles is shiny
                    for x2 = x - 1, x - matchNum, -1 do
                        if self.tiles[y][x2].isShiny then
                            foundShiny = true
                        end
                    end

                    if foundShiny then
                        for x2 = 1, 8 do
                            table.insert(match, self.tiles[y][x2])
                        end
                    end

                    if not foundShiny then

                        -- go backwards from here by matchNum
                        for x2 = x - 1, x - matchNum, -1 do
                            
                            -- add each tile to the match that's in that match
                            table.insert(match, self.tiles[y][x2])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum 
            --and check if one of the tiles is shiny
            local foundShiny = false
            for x = 8, 8 - matchNum + 1, -1 do
                if self.tiles[y][x].isShiny then 
                    foundShiny = true 
                end
            end

            if foundShiny == true then
                for x = 1, 8 do
                    table.insert(match, self.tiles[y][x])
                end
            end

            if not foundShiny then
            -- go backwards from end of last row by matchNum
                for x = 8, 8 - matchNum + 1, -1 do
                    table.insert(match, self.tiles[y][x])
                end
            end
            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                        
                        --if one of the tiles is shiny, iterate over the row from that tile and
                        --insert each tile in the match table
                        if self.tiles[y2][x].isShiny then
                            for x2 = 1, 8 do
                                table.insert(match, self.tiles[y2][x2])
                            end
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y2 = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y2][x])
                
                --if one of the tiles is shiny, iterate over the row from that tile and
                --insert each tile in the match table
                if self.tiles[y2][x].isShiny then
                    for x2 = 1, 8 do
                        table.insert(match, self.tiles[y2][x2])
                    end
                end
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety

                                --the color is going to be a random value        variety for each new tile after the first board
                                --between 0 and the quantity of colors in       is the minimun value between the current level and 6, 
                                --self.colors                                      meaning, for each level, increases the variety by 1
                local tile =Tile(x, y, self.colors[math.random(#self.colors)], math.min(math.random(self.level+1), 6))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

--Function that check if a movement will cause a match
function Board:willThereBeMatch(tile, x, y)
    -- To check whether 3 tiles in a row have the same color
    local allSameColor = true

    -- Horizontal color neighborhood
    local hNeighborhood = {}
    local xMin = math.max(1, x - 2)
    local xMax = math.min(8, x + 2)
    for j = xMin, xMax do
        table.insert(hNeighborhood, j, self.tiles[y][j].color)
    end

    -- Move the color horizontally if it is necessary
    hNeighborhood[tile.gridX] = hNeighborhood[x]
    hNeighborhood[x] = tile.color

    -- Window shift to check for match
    for j1 = xMin, xMax - 2 do
        allSameColor = true
        -- Check the current window
        for j2 = j1, j1 + 2 do
            allSameColor = allSameColor and hNeighborhood[j2] == tile.color    
        end

        -- if the window has all tiles with the same color, there is match
        if allSameColor then
            return true
        end
    end

    -- The same previous thing but vertically
    local vNeighborhood = {}
    local yMin = math.max(1, y - 2)
    local yMax = math.min(8, y + 2)
    
    for i = yMin, yMax do
        table.insert(vNeighborhood, i, self.tiles[i][x].color)
    end

    vNeighborhood[tile.gridY] = vNeighborhood[y]
    vNeighborhood[y] = tile.color

    for i1 = yMin, yMax - 2 do
        allSameColor = true
        for i2 = i1, i1 + 2 do
            allSameColor = allSameColor and vNeighborhood[i2] == tile.color    
        end
        if allSameColor then
            return true
        end
    end
    
    return false
end

--Function that check if a tile can be moved to the selected position
function Board:canMove(tile, x, y)
    if x < 1 or x > 8 or y < 1 or y > 8 then
        return false
    end

    return self:willThereBeMatch(tile, x, y) or self:willThereBeMatch(self.tiles[y][x], tile.gridX, tile.gridY)
end

--Function that checks if exists any match in the board

function Board:existsMatch()
    for y = 1, 8 do
        for x = 1, 8 do
            tile = self.tiles[y][x]
            if self:canMove(tile, x - 1, y) or self:canMove(tile, x + 1, y) or self:canMove(tile, x, y - 1) or self:canMove(tile, x, y + 1) then
                print("Can move:", tostring(x), tostring(y))
                return true
            end
        end
    end
    print("No movements available")
    return false
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end