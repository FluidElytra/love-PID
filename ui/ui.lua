require "ui/slidebar"
require "ui/slidebutton"
require "ui/button"
require "ui/textbox"

Ui = Object:extend()


function Ui:new(font)
	self.font = font
	
	-- textboxes
	self.textbox = {}
	
	-- slidebars
	self.slidebar = {}
	self.slidebar[0] = Slidebar("P", 60, 50, 3, 1, 15, self.font) -- N_iter
	self.slidebar[0].bubble_info = "Coefficient proportionnel"

	self.slidebar[1] = Slidebar("I", 60, 80, 3, 1, 15, self.font) -- N_iter
	self.slidebar[1].bubble_info = "Coefficient intégral"

	self.slidebar[2] = Slidebar("D", 60, 110, 3, 1, 15, self.font) -- N_iter
	self.slidebar[2].bubble_info = "Coefficient dérivé"

	-- buttons
	self.button = {} -- button list
	-- self.button[0] = Button(270,380,80,30,0,"Refresh",self.font)
	-- self.button[0].func = function() end
end


function Ui:update()
	-- -- buttons
	-- for i = 0, #self.button do
	-- 	self.button[i]:update()
	-- end
	-- slidebars
	for i = 0, #self.slidebar do 
		self.slidebar[i]:update()
	end
	-- -- textboxes
	-- for i = 0, #self.textbox do 
	-- 	self.textbox[i]:update()
	-- end
end


function Ui:draw()
	-- buttons
	-- for i = 0, #self.button do -- draw menu buttons
	-- 	self.button[i]:draw()
	-- end
	-- slidebars
	for i = 0, #self.slidebar do -- draw menu buttons
		self.slidebar[i]:draw()
	end
	-- textboxes
	-- for i = 0, #self.textbox do 
	-- 	self.textbox[i]:draw()
	-- end
end


