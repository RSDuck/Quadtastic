local Rectangle = require("Rectangle")
local renderutils = require("Renderutils")
local Label = {}

-- Displays the passed in label. Returns, in this order, whether the label
-- is active (i.e. getting clicked on), and whether the mouse is over this
-- label.
Label.draw = function(state, x, y, w, h, label)
  local margin_x = 4
  local textwidth = state.style.font and state.style.font:getWidth(label)
  w = w or math.max(32, 2*margin_x + (textwidth or 32))
  h = h or 18

  -- Print label
  love.graphics.setColor(32, 63, 73, 255)
  local margin_y = (h - 16) / 2
  love.graphics.print(label or "", x + margin_x, y + margin_y)

  local active, hover = false, false
  -- Highlight if mouse is over button
  if state and state.mouse and 
    Rectangle(x, y, w, h):contains(state.mouse.x, state.mouse.y)
  then
    hover = true
    if state.mouse.buttons[1] and state.mouse.buttons[1].pressed then
      active = true
    end
  end
  return active, hover
end

return Label