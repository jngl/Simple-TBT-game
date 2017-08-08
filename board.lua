board = {
   --constant
   width = 20,
   height = 15,
   posX = 10,
   posY = 30,
   tileWidth = 40,
   tileHeight = 30,
   blueUnits = {},
   redUnits = {},
   unitWidth = 20,
   unitHeight = 15,
   unitPosX = 10,
   unitPosY = 7,

   --var
   blueUnits = {},
   redUnits = {},
   walls = {},
   moveDist = {},

   genWalls = function()
      x = 0
      y = 0
      while x<board.width do
	 y=0
	 board.walls[x] = {}
	 while y<board.height do
	    if math.random()<0.2 then
	       board.walls[x][y]=true
	    else
	       board.walls[x][y]=false
	    end
	    y = y + 1
	 end
	 x = x + 1
      end
   end,
   
   drawTile = function(x, y)
      tilePosX = board.posX + (board.tileWidth+2)*x
      tilePosY = board.posY + (board.tileHeight+2)*y

      if board.walls[x][y] then
	 love.graphics.setColor( 0, 0, 0, 255)
      else
	 if (x%2==0 and y%2==0) or (x%2~=0 and y%2~=0) then
	    if game.movable(x, y) then
	       love.graphics.setColor( 0, 205, 0, 255 )
	    else
	       love.graphics.setColor( 205, 205, 205, 255 )
	    end
	 else
	    if game.movable(x, y) then
	       love.graphics.setColor( 0, 150, 0, 255 )
	    else
	       love.graphics.setColor( 150, 150, 150, 255 )
	    end
	 end
      end
      
      love.graphics.rectangle("fill",
			      tilePosX,
			      tilePosY,
			      board.tileWidth,
			      board.tileHeight )
      
   end,

   drawUnit = function(unit, blue)
      local drawPosX = board.posX + (board.tileWidth+2)*unit.x + board.unitPosX
      local drawPosY = board.posY + (board.tileHeight+2)*unit.y + board.unitPosY
      if blue then
	 if unit == game.selectUnit then
	    love.graphics.setColor( 96, 125, 190, 255 )
	 else
	    love.graphics.setColor( 36, 65, 130, 255 )
	 end
      else
	 if unit == game.selectUnit then
	    love.graphics.setColor( 230, 108, 87, 255 )
	 else
	    love.graphics.setColor( 170, 48, 27, 255 )
	 end
      end
      
      if unit.pv>0 then
	 love.graphics.rectangle("fill",
				 drawPosX,
				 drawPosY,
				 board.unitWidth,
				 board.unitHeight )

	 if unit.chef then
	    love.graphics.setColor( 255, 206, 61, 255 )
	    love.graphics.rectangle("line",
				    drawPosX,
				    drawPosY,
				    board.unitWidth,
				    board.unitHeight )
	 end

	 --pv
	 love.graphics.setColor( 150, 0, 0, 255 )
	 love.graphics.rectangle("fill",
				 drawPosX,
				 drawPosY-4,
				 board.unitWidth*unit.pv/100,
				 2 )
      else
	 love.graphics.rectangle("line",
				 drawPosX,
				 drawPosY,
				 board.unitWidth,
				 board.unitHeight )
      end
   end,

   getBlueUnit = function(posX, posY)
      for key,unit in pairs(board.blueUnits) do
	 if unit.x==posX and unit.y==posY then
	    return unit
	 end
      end
      return nil
   end,

   getRedUnit = function(posX, posY)
      for key,unit in pairs(board.redUnits) do
	 if unit.x==posX and unit.y==posY then
	    return unit
	 end
      end
      return nil
   end,

   draw = function()
      x = 0
      y = 0
      while x<board.width do
	 y=0
	 while y<board.height do
	    board.drawTile(x, y)
	    y = y + 1
	 end
	 x = x + 1
      end

      for key,unit in pairs(board.blueUnits) do
	 board.drawUnit(unit, true)
      end

      for key,unit in pairs(board.redUnits) do
	 board.drawUnit(unit, false)
      end
   end,

   newBlueUnit = function(posX, posY, pchef)
      table.insert(board.blueUnits, {x = posX, y = posY, pv = 100, chef=pchef})
   end,

   newRedUnit = function(posX, posY, pchef)
      table.insert(board.redUnits, {x = posX, y = posY, pv = 100, chef=pchef})
   end,

   genDistMap = function()
      x = 0
      y = 0
      while x<board.width do
	 y=0
	 board.moveDist[x] = {}
	 while y<board.height do
	    board.moveDist[x][y] = 9999
	    y = y + 1
	 end
	 x = x + 1
      end
      listTile = {}
      table.insert(listTile, {x=game.selectUnit.x, y=game.selectUnit.y, dist=0})
      while #listTile ~= 0 do
	 tile = table.remove(listTile)
	 board.moveDist[tile.x][tile.y] = tile.dist
	 if tile.x>0 and not board.walls[tile.x-1][tile.y] and tile.dist+1<board.moveDist[tile.x-1][tile.y] then
	    table.insert(listTile, {x = tile.x-1, y = tile.y, dist=tile.dist+1})
	 end
	 if tile.x+1 < board.width and not board.walls[tile.x+1][tile.y] and tile.dist+1<board.moveDist[tile.x+1][tile.y] then
	    table.insert(listTile, {x = tile.x+1, y = tile.y, dist=tile.dist+1})
	 end
	 if tile.y>0 and not board.walls[tile.x][tile.y-1] and tile.dist+1<board.moveDist[tile.x][tile.y-1] then
	    table.insert(listTile, {x = tile.x, y = tile.y-1, dist=tile.dist+1})
	 end
	 if tile.y+1<board.height and not board.walls[tile.x][tile.y+1] and tile.dist+1<board.moveDist[tile.x][tile.y+1] then
	    table.insert(listTile, {x = tile.x, y = tile.y+1, dist=tile.dist+1})
	 end
      end
   end
}
