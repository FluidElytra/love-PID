System = Object:extend()

local CMU_typewriter = love.graphics.newFont("fonts/computer-modern/cmuntb.ttf", 15)
local pink = {228/255, 167/255, 239/255, 1}
local green = {80/255, 250/255, 123/255, 1}
local white = {1, 1, 1, 1}
local selector_velocity = 0.5 -- increase the selector diameter every time step
local bubble_velocity = 0.5

function System:new(x, y, value, inf, sup, consigne)
	--- x, y : position of the slide bar (does not include the label)
	-- value : initial value (scalar)
	-- inf, supp : min and max value the Slidebar may return (scalars)

	self.x = x
	self.y = y
	self.value = value
	self.inf = inf
	self.sup = sup
	self.font = CMU_typewriter

	self.bubble_info = ""
	self.bubble_alpha = 0

	self.w = 350
	self.h = 7
	self.selector_r = 15
	self.selector_r0 = 15

	self.color_label = white
	self.color_selector = white
	self.color_main = white
	self.color_value = green

	self.max_value = sup
	
	self.state = "none"

	self.consigne = consigne
	self.error = self.value - self.consigne

	local x0 = math.ceil(self.x + (self.value-self.inf) * self.w/(self.sup - self.inf))
 	self.selectorPosition = Vector(x0,y+self.h*0.5) -- position initiale
 	self.integral = 0
end


function System:update()
	-- User interaction
	if self:collideAll() then -- is the item flight over ?
		if self.state ~= "clicked" then
			self.state = "fly"
		end
		if love.mouse.isDown(1) and self:collide() then -- is the item clicked ?
			self.state = "clicked"
			self.integral = 0
			-- drag
			local x, y = love.mouse.getPosition()
			if self.selectorPosition.x <= self.x + self.w and self.selectorPosition.x >= self.x then -- bug
				self.selectorPosition.x = x
			end
			-- growth animation
			if self.selector_r < 1.25 * self.selector_r0 then
				self.selector_r = self.selector_r + selector_velocity
			end
			-- convert position to value
			self.value = math.ceil(self.inf + (self.selectorPosition.x - self.x) * (self.sup - self.inf)/self.w) -- update output value
			-- antibug
			if self.value > self.max_value then
				self.value = self.max_value
				-- update selector position
				self.selectorPosition.x =  math.ceil(self.x + (self.value-self.inf) * self.w/(self.sup - self.inf))
			end
		else
			if self.state ~= "clicked" then
				self.state = "fly"
			end
			-- decay animation
			if self.selector_r > self.selector_r0 then
				self.selector_r = self.selector_r - selector_velocity
			end

		end

	else
		self.state = "none"
	end
	-- Dynamic system
	local velocity = -0.4
	self.value = self.value + velocity

	-- PID algorith
	self.error = - self.value + self.consigne
	local K_p = 0.1
	local K_i = 0.01
	if self.state ~= "clicked" then
		if math.ceil(self.error) ~= 0 then
			self.integral = self.integral + self.error -- to reset when clicked
			self.value = self.value + K_p * self.error + K_i * self.integral -- new value
		end
		self.selectorPosition.x =  math.ceil(self.x + (self.value-self.inf) * self.w/(self.sup - self.inf))
	end
end


function System:draw()
	self.color_value[4] = 0
	if self.state == "none" then
		self.color_label = white
		self.color_selector = white
		self.color_main = white
	elseif self.state == "fly" then
		self.color_label = pink
		self.color_selector = pink
		self.color_main = pink
	elseif self.state == "clicked" then
		self.color_selector = pink
		self.color_value[4] = 1
	end

	local yoffset = 8

	-- bar and inf and sup labels
	love.graphics.setColor(self.color_main)
	love.graphics.printf(self.inf,self.font,self.x-55,self.y-yoffset,50,"right",0,1,1) -- inf
	love.graphics.printf(self.sup,self.font,self.x+self.w+5,self.y-yoffset,50,"left",0,1,1) -- sup
	love.graphics.rectangle("fill", self.x, self.y,self.w, self.h)

	-- selector
	love.graphics.setColor(self.color_selector)
	love.graphics.circle("fill", self.selectorPosition.x, self.selectorPosition.y, self.selector_r)
	
	-- value
	love.graphics.setColor(self.color_value)
	love.graphics.printf(self.value,self.font,self.selectorPosition.x-20,self.selectorPosition.y-42,40,"center",0,1,1)
	if self.value == self.max_value then
		love.graphics.printf("max",self.font,self.selectorPosition.x-20,self.selectorPosition.y+10,40,"center",0,1,1)
	end

	-- consigne
	love.graphics.setColor(1, 1, 1, 1)

	-- miscellaneous info
	love.graphics.setColor(1, 1, 1, 1)
	local x_info, y_info = 100, 300
	love.graphics.printf("error :",self.font,x_info,y_info,60,"left",0,1,1)
	love.graphics.printf(math.ceil(self.error),self.font,x_info+60,y_info,60,"left",0,1,1)
	love.graphics.printf("value :",self.font,x_info,y_info+30,60,"left",0,1,1)
	love.graphics.printf(math.ceil(self.value),self.font,x_info+60,y_info+30,60,"left",0,1,1)

	love.graphics.setColor(1, 1, 1, 1)
end


function System:collide()
	local tolerance = 1.5 
	-- true if the mouse is on the button
	local x, y = love.mouse.getPosition()
	local r = math.sqrt((x-self.selectorPosition.x)^2+(y-self.selectorPosition.y)^2)
	if r < self.selector_r*tolerance then
		return true
	else
		return false
	end
end


function System:collideAll()
	-- true if the mouse is on the button
	local x,y = love.mouse.getPosition()
	if x > self.x and x < self.x + self.w and y < self.y + 1.5*self.selector_r and y > self.y - 1.5*self.selector_r then
		return true
	else
		return false
	end
end

function System:passValue(value)
	self.selectorPosition.x = self.x + (self.value - self.inf) * self.w/(self.sup - self.inf)
	self.value = value
end