local current_folder = ... and (...):match '(.-%.?)[^%.]+$' or ''
local Layout = require(current_folder .. ".Layout")
local imgui = require(current_folder .. ".imgui")
local Button = require(current_folder .. ".Button")

local Menu = {}

function Menu.menubar_start(gui_state, w, h)
  imgui.push_style(gui_state, "font", gui_state.style.small_font)
  -- Shift the menu bar by a few pixel so that the leftmost menu has enough room
  -- to move a bit to the left. That leads to a nice tab-like effect where
  -- the rounded corners of the menu line up with the outline of the menubar
  -- entries
  local tl_w = gui_state.style.raw_quads.menu.tl.w
  Layout.start(gui_state, tl_w, 0, w, h, {noscissor = true})
end

function Menu.menubar_finish(gui_state)
  Layout.finish(gui_state, "-")
  imgui.pop_style(gui_state, "font")
end

function Menu.menu_start(gui_state, w, h, label)
  -- Cache current x and y
  local x = gui_state.layout.next_x
  local y = gui_state.layout.next_y

  local options = {}

  local opened = imgui.is_menu_open(gui_state, label)

  if opened then
    options.bg_color_default =
      gui_state.menu_depth == 0 and {202, 222, 227} or {68, 137, 156}
  end
  -- Draw label depending on current menu depth
  local hit
  if gui_state.menu_depth == 0 then
    hit = Menu.menubar_item(gui_state, label, options)
  else
    hit = Menu.menu_item(gui_state, label, options)
    love.graphics.setColor(255, 255, 255)
    local arrow_w = gui_state.style.raw_quads.menu.arrow.w
    local arrow_h = gui_state.style.raw_quads.menu.arrow.h
    local arrow_x = x + w - arrow_w - 2
    local arrow_y = y + (16 - arrow_h) / 2
    love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.arrow,
      arrow_x, arrow_y)
  end

  if hit then
    imgui.toggle_menu(gui_state, label)
  end

  if opened then
    love.graphics.push("all")
    love.graphics.setCanvas(gui_state.overlay_canvas)

    -- Calculate position of new menu depending on current menu depth
    local deco_height = gui_state.style.raw_quads.menu.t.h
    local tl_w = gui_state.style.raw_quads.menu.tl.w
    local tr_w = gui_state.style.raw_quads.menu.tr.w
    local t_w = gui_state.style.raw_quads.menu.t.w
    if gui_state.menu_depth == 0 then
      y = y + 12
      -- Shift menu to the left by a few pixels so that the rounded corners
      -- of the menu line up with the outline of the menubar entry
      x = x - tl_w
    else
      y = y - deco_height
      x = x + w
    end

    -- Draw decoration at the top
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.tl, x, y)
    assert(t_w == 1)
    love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.t,
      x + tl_w, y, 0, w - tl_w - tr_w, 1)
    love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.tr,
      x + w - tr_w, y)

    y = y + deco_height

    Layout.start(gui_state, x, y, w, h - 2*deco_height, {noscissor = true})
    gui_state.menu_depth = gui_state.menu_depth + 1
  end

  return opened
end

function Menu.menu_finish(gui_state, w, h)
  local x = gui_state.layout.next_x
  local y = gui_state.layout.next_y

  -- Draw decoration at the bottom
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.bl, x, y)
  local tl_w = gui_state.style.raw_quads.menu.bl.w
  local tr_w = gui_state.style.raw_quads.menu.br.w
  local t_w = gui_state.style.raw_quads.menu.b.w
  assert(t_w == 1)
  love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.b,
    x + tl_w, y, 0, w - tl_w - tr_w, 1)
  love.graphics.draw(gui_state.style.stylesheet, gui_state.style.quads.menu.br,
    x + w - tr_w, y)

  Layout.finish(gui_state, "|")

  gui_state.layout.adv_x = 0
  gui_state.layout.adv_y = 0
  love.graphics.setCanvas()
  love.graphics.pop()
  assert(gui_state.menu_depth > 0, "Ending menu on menu depth 0. Did you forget menu_start?")
  gui_state.menu_depth = gui_state.menu_depth - 1
end

local function draw_item_background(gui_state, h)
  local x = gui_state.layout.next_x
  local y = gui_state.layout.next_y
  local w = gui_state.layout.max_w
  love.graphics.setColor(202, 222, 227)
  love.graphics.rectangle("fill", x, y, w, h)
end

function Menu.menu_item(gui_state, label, options)
  draw_item_background(gui_state, 16)
  options = options or {}
  if options.disabled then
    options.font_color = {128, 128, 128}
  elseif not options.font_color then options.font_color = {0, 0, 0, 255} end
  if not options.bg_color_hovered then options.bg_color_hovered = {68, 137, 156} end
  if not options.bg_color_pressed then options.bg_color_pressed = {42, 82, 94} end

  local clicked = Button.draw_flat(gui_state, nil, nil, gui_state.layout.max_w, nil,
    label, nil, options)
  Layout.next(gui_state, "|")

  clicked = clicked and (not options or options and not options.disabled)
  if clicked then
    imgui.close_menus(gui_state, gui_state.menu_depth)
  end
  return clicked
end

-- Behaves like a menu item, but closes all menus when clicked.
function Menu.action_item(gui_state, label, options)
  local clicked = Menu.menu_item(gui_state, label, options)
  if clicked then
    imgui.close_menus(gui_state)
  end
  return clicked
end

function Menu.separator(gui_state)
  draw_item_background(gui_state, 3)
  local x = gui_state.layout.next_x + 2
  local y = gui_state.layout.next_y + 1
  local w = gui_state.layout.max_w - 4
  love.graphics.setColor(32, 63, 73)
  love.graphics.rectangle("fill", x, y, w, 1)
  gui_state.layout.adv_x = 0
  gui_state.layout.adv_y = 3
  Layout.next(gui_state, "|")
end

function Menu.menubar_item(gui_state, label, options)
  options = options or {}
  if options.disabled then
    options.font_color = {128, 128, 128}
  else
    options.font_color = {0, 0, 0, 255}
  end
  local clicked = Button.draw_flat(gui_state, nil, nil, nil, gui_state.layout.max_h,
    label, nil, options)
  Layout.next(gui_state, "-", 1)
  return clicked
end

return Menu