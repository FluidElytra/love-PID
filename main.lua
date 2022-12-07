Object = require "lib/classic"
Vector = require "lib/hump.vector"
Timer = require "lib/hump.timer"
require "ui/ui"
require "system"

darkgrey = {24/255,25/255,32/255,1}
CMU_typewriter = love.graphics.newFont("fonts/computer-modern/cmuntb.ttf", 15)

love.graphics.setBackgroundColor(darkgrey)
love.window.setMode(500, 600)
love.window.setTitle('PID')

function love.load()
	UI = Ui(CMU_typewriter)

	-- SYSTEM
	local consigne = 10
	system = System(60, 200, consigne, 1, 1000, 750)
end


function love.update(dt)
	UI:update()

	-- SYSTEM
	system:update()
end


function love.draw()
	UI:draw()
	
	-- SYSTEM
	system:draw()
end