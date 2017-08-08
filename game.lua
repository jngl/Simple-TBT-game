game = {
   maxMove = 5,
   
   PlaceRed = {
      update = function(x, y)
	 if not board.walls[x][y] and board.getBlueUnit(x, y) == nil and board.getRedUnit(x, y) == nil then
	    board.newRedUnit(x, y, #board.redUnits==0)
	    if #board.redUnits >=5 then
	       game.currentState = game.SelectBlueUnit
	    end
	 end
      end,
      name = "Place red unit"
   },
   
   PlaceBlue = {
      update = function(x, y)
	 if not board.walls[x][y] and board.getBlueUnit(x, y) == nil then
	    board.newBlueUnit(x, y, #board.blueUnits==0)
	    if #board.blueUnits >=5 then
	       game.currentState = game.PlaceRed
	    end
	 end
      end,
      name = "Place blue unit"
   },
   
   SelectBlueUnit = {
      update = function(x, y)
	 unit = board.getBlueUnit(x, y)
	 if unit ~= nil and unit.pv>0 then
	    game.selectUnit = unit
	    game.currentState = game.MoveBlueUnit
	    board.genDistMap()
	 end
      end,
      name = "Select blue unit"
   },
   
   SelectRedUnit = {
      update = function(x, y)
	 unit = board.getRedUnit(x, y)
	 if unit ~= nil and unit.pv>0 then
	    game.selectUnit = unit
	    game.currentState = game.MoveRedUnit
	    board.genDistMap()
	 end
      end,
      name = "Select red unit"
   },
   
   MoveBlueUnit = {
      update = function (x, y)
	 if game.moveUnit(game.selectUnit, x, y) then
	    game.selectUnit =nil 
	    game.currentState = game.SelectRedUnit
	    
	    unit = board.getRedUnit(x+1, y)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x+2][y] and board.getRedUnit(x+2, y)==nil and board.getBlueUnit(x+2, y)==nil then
		  unit.x=unit.x+1
	       end
	    end

	    unit = board.getRedUnit(x, y+1)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x][y+2] and board.getRedUnit(x, y+2)==nil and board.getBlueUnit(x, y+2)==nil then
		  unit.y=unit.y+1
	       end
	    end

	    unit = board.getRedUnit(x-1, y)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x-2][y] and board.getRedUnit(x-2, y)==nil and board.getBlueUnit(x-2, y)==nil then
		  unit.x=unit.x-1
	       end
	    end

	    unit = board.getRedUnit(x, y-1)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x][y-2] and board.getRedUnit(x, y-2)==nil and board.getBlueUnit(x, y-2)==nil then
		  unit.y=unit.y-1
	       end
	    end
	 end
      end,
      name = "Move blue unit"
   },
   
   MoveRedUnit = {
      update = function(x, y)
	 if game.moveUnit(game.selectUnit, x, y) then
	    game.selectUnit =nil 
	    game.currentState  = game.SelectBlueUnit

	    unit = board.getBlueUnit(x+1, y)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x+2][y] and board.getRedUnit(x+2, y)==nil and board.getBlueUnit(x+2, y)==nil then
		  unit.x=unit.x+1
	       end
	    end

	    unit = board.getBlueUnit(x, y+1)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x][y+2] and board.getRedUnit(x, y+2)==nil and board.getBlueUnit(x, y+2)==nil then
		  unit.y=unit.y+1
	       end
	    end

	    unit = board.getBlueUnit(x-1, y)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x-2][y] and board.getRedUnit(x-2, y)==nil and board.getBlueUnit(x-2, y)==nil then
		  unit.x=unit.x-1
	       end
	    end

	    unit = board.getBlueUnit(x, y-1)
	    if unit~=nil then
	       unit.pv=unit.pv-50
	       if not board.walls[x][y-2] and board.getRedUnit(x, y-2)==nil and board.getBlueUnit(x, y-2)==nil then
		  unit.y=unit.y-1
	       end
	    end
	 end
      end,
      name = "Move red unit"
   },

   moveUnit = function(unit, x, y)
      if board.getRedUnit(x, y) == nil and
	 board.getBlueUnit(x, y) == nill and
	 board.walls[x][y] == false and
      game.movable(x, y) then
	 game.selectUnit.x = x
	 game.selectUnit.y = y
	 return true
      end
      return false
   end,

   movable = function(x, y)
      if game.selectUnit == nil then
	 return false
      end

      if board.moveDist[x][y]<=game.maxMove then
	 return true
      end
      
      return false
   end,
   
   load = function()
      game.currentState = game.PlaceBlue
      board.genWalls()
   end,
   
   update = function(x, y)
      game.currentState.update(selectX, selectY)
   end,
   
   draw = function()
      board.draw()
      love.graphics.setColor( 0, 0, 0, 255 )
      love.graphics.print(game.currentState.name, 10, 10)
   end
}

