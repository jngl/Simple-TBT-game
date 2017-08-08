dofile "board.lua"
dofile "game.lua"

function love.load()
   love.window.setMode(870, 520,
		       {resizable=false,
			vsync=false,
			minwidth=400,
			minheight=300})
   
   love.graphics.setBackgroundColor( 255, 255, 255 )
   game.load()
end

function love.mousepressed(x, y, button, istouch)
   selectX = math.floor( (x - board.posX)/(board.tileWidth+2) )
   selectY = math.floor( (y - board.posY)/(board.tileHeight+2) )
   if love.keyboard.isDown('e') then
      board.walls[selectX][selectY] = not board.walls[selectX][selectY]
   else
      game.update(selectX, selectY)
   end
end

function love.draw()
   game.draw()
end
