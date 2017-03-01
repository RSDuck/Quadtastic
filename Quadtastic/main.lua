local inspect = require("lib/inspect")

unpack = unpack or table.unpack

if os.getenv("DEBUG") then
  require("lib/lovedebug/lovedebug")
  require("debugconfig")
end

local imgui = require("imgui")

local Button = require("Button")
local Inputfield = require("Inputfield")
local Label = require("Label")
local Frame = require("Frame")
local gui_state
local state = {
  filepath = "res/style.png", -- the path to the file that we want to edit
  image = nil, -- the loaded image
  display = {
    x = 0, -- the x offset where the image should start, in screen coords
    y = 0, -- the y offset where the image should start, in screen coords
    tx = 0, -- target translate translation in x
    ty = 0, -- target translate translation in y
    last_dx = 0, -- last translate speed in x
    last_dy = 0, -- last translate speed in y
    zoom = 1, -- additional zoom factor for the displayed image
  },
}

-- Scaling factor
local scale = 2

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  font = love.graphics.newFont("res/m5x7.ttf", 16)
  love.graphics.setFont(font)

  stylesprite = love.graphics.newImage("res/style.png")

  backgroundcanvas = love.graphics.newCanvas(8, 8)
  do
    -- Create a canvas with the background texture on it
    backgroundquad = love.graphics.newQuad(48, 16, 8, 8, 128, 128)
    backgroundcanvas:setWrap("repeat", "repeat")
    backgroundcanvas:renderTo(function()
      love.graphics.draw(stylesprite, backgroundquad)
    end)
  end

  love.keyboard.setKeyRepeat(true)
  gui_state = imgui.init_state()
  gui_state.style.font = font
end

local count = 0
function love.draw()
  imgui.begin_frame(gui_state)
  love.graphics.scale(scale, scale)

  love.graphics.clear(203, 222, 227)
  Label.draw(gui_state, 2, 2, nil, nil, "File:")
  state.filepath = Inputfield.draw(gui_state, 30, 2, 160, nil, state.filepath)

  local pressed, active = Button.draw(gui_state, 200, 2, nil, nil, "Doggo!!")
  if pressed then 
    success, more = pcall(love.graphics.newImage, state.filepath)
    if success then
      state.image = more
    else
      print(more)
    end
  end
  Frame.start(gui_state, 2, 24, 400 - 2, 160)
  love.graphics.translate(state.display.x, state.display.y)
  backgroundquad = love.graphics.newQuad(0, 0, 400, 300, 8, 8)
  love.graphics.draw(backgroundcanvas, backgroundquad, 4, 26, 0,
                     state.display.zoom, state.display.zoom)
  if state.image then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(state.image, 4, 26, 0,
                       state.display.zoom, state.display.zoom)
  end
  Frame.finish()
  do
    local pressed = Button.draw(gui_state, 2, 300 - 16, 13, 14, "+")
    if pressed then
      state.display.zoom = math.min(12, state.display.zoom + 1)
    end
  end
  do
    local pressed = Button.draw(gui_state, 14, 300 - 16, 13, 14, "-")
    if pressed then
      state.display.zoom = math.max(1, state.display.zoom - 1)
    end
  end

  -- Image panning
  
  local friction = 0.5
  local threshold = 3

  if gui_state.mouse.wheel_dx ~= 0 then
    state.display.tx = state.display.x - 2*gui_state.mouse.wheel_dx
  elseif math.abs(state.display.last_dx) > threshold then
    state.display.tx = state.display.x + state.display.last_dx
  end
  local dx = friction * (state.display.tx - state.display.x)

  if gui_state.mouse.wheel_dy ~= 0 then
    state.display.ty = state.display.y + 2*gui_state.mouse.wheel_dy
  elseif math.abs(state.display.last_dy) > threshold then
    state.display.ty = state.display.y + state.display.last_dy
  end
  local dy = friction * (state.display.ty - state.display.y)

  -- Apply the translation change
  state.display.x = state.display.x + dx
  state.display.y = state.display.y + dy
  -- Remember the last delta to possibly trigger floating in the next frame
  state.display.last_dx = dx
  state.display.last_dy = dy

  imgui.end_frame(gui_state)
end

local function unproject(x, y)
  return x / scale, y / scale
end

function love.mousepressed(x, y, button)
  x, y = unproject(x, y)
  imgui.mousepressed(gui_state, x, y, button)
end

function love.mousereleased(x, y, button)
  x, y = unproject(x, y)
  imgui.mousereleased(gui_state, x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  x ,  y = unproject(x ,  y)
  dx, dy = unproject(dx, dy)
  imgui.mousemoved(gui_state, x, y, dx, dy)
end

function love.wheelmoved(x, y)
  imgui.wheelmoved(gui_state, x, y)
end

function love.keypressed(key, scancode, isrepeat)
  imgui.keypressed(gui_state, key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
  imgui.keyreleased(gui_state, key, scancode, isrepeat)
end

function love.textinput(text)
  imgui.textinput(gui_state, text)
end

function love.update(dt)
  imgui.update(state, dt)
end
