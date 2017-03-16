local Layout = require("Quadtastic/Layout")
local Rectangle = require("Quadtastic/Rectangle")
local affine = require("lib/affine")
local imgui = require("Quadtastic/imgui")

local Scrollpane = {}

local scrollbar_margin = 7

local function handle_input(state, scrollpane_state, w, h)
	assert(state.input)

	-- Only handle image panning if the mousewheel was triggered inside
	-- this widget.
	if Scrollpane.is_mouse_inside_widget(state, scrollpane_state) then
    	local threshold = 3
		if state.input.mouse.wheel_dx ~= 0 then
			scrollpane_state.tx = scrollpane_state.x + 4*state.input.mouse.wheel_dx
		elseif math.abs(scrollpane_state.last_dx) > threshold then
			scrollpane_state.tx = scrollpane_state.x + scrollpane_state.last_dx
		end
		if state.input.mouse.wheel_dy ~= 0 then
			scrollpane_state.ty = scrollpane_state.y - 4*state.input.mouse.wheel_dy
		elseif math.abs(scrollpane_state.last_dy) > threshold then
			scrollpane_state.ty = scrollpane_state.y + scrollpane_state.last_dy
		end
	end
end

-- Moves the viewport's focus by the given delta as far as possible
-- without violating the bounds set in the scrollpane state
local move_viewport_within_bounds = function(sp_state, dx, dy)
	local new_x, new_y = sp_state.x + dx, sp_state.y + dy

	if sp_state.min_x then 
		new_x = math.max(sp_state.min_x, new_x)
	end
	if sp_state.min_y then 
		new_y = math.max(sp_state.min_y, new_y)
	end
	if sp_state.max_x then 
		new_x = math.min(sp_state.max_x - sp_state.w, new_x)
	end
	if sp_state.max_y then 
		new_y = math.min(sp_state.max_y - sp_state.h, new_y)
	end

	sp_state.x = new_x
	sp_state.y = new_y
end

-- Move the scrollpane to focus on the given bounds.
-- Might be restricted by the inner bounds in the scrollpane_state
-- (i.e. when moving to the first item, it will not center the viewport on
-- that item, but rather have the viewport's upper bound line up with the upper
-- bound of that item.)
local apply_focus = function(gui_state, scrollpane_state)
	assert(gui_state)
	assert(scrollpane_state)
	assert(scrollpane_state.focus)

	local bounds = scrollpane_state.focus

	-- We cannot focus on a specific element if we don't know the viewport's
	-- dimensions
	if not (scrollpane_state.w or scrollpane_state.h) then return end

	-- Try to center the scrollpane viewport on the given bounds, but without
	-- exceeding the limits set in the scrollpane state

	local center_bounds = {}
	center_bounds.x, center_bounds.y = Rectangle.center(bounds)
	-- This works because the scrollpane has x, y, w and h
	local center_vp = {}
	center_vp.x, center_vp.y = Rectangle.center(scrollpane_state)

	local dx, dy = center_bounds.x - center_vp.x, center_bounds.y - center_vp.y
	local x, y = scrollpane_state.x + dx, scrollpane_state.y + dy

	-- In immediate mode both the current and the target location are changed
	if bounds.mode and bounds.mode == "immediate" then
		move_viewport_within_bounds(scrollpane_state, dx, dy)
	end
	-- Otherwise only the target position is changed
	scrollpane_state.tx = x
	scrollpane_state.ty = y

	scrollpane_state.focus = nil
end

-- Mode can be either "immediate" or "transition". Immediate makes the viewport
-- jump to the target position on the next frame, while transition causes a
-- smoother transition.
Scrollpane.set_focus = function(scrollpane_state, bounds, mode)
	scrollpane_state.focus = {
		x = bounds.x,
		y = bounds.y,
		w = bounds.w,
		h = bounds.h,
		mode = mode,
	}
end

Scrollpane.is_in_viewport = function(scrollpane_state, bounds)
	return Rectangle.contains(scrollpane_state, bounds.x, bounds.y, bounds.w, bounds.h)
end

Scrollpane.move_into_view = function(scrollpane_state, bounds, mode)
	if Scrollpane.is_in_viewport(scrollpane_state, bounds) then return
	else
		scrollpane_state.focus = {
			x = bounds.x,
			y = bounds.y,
			w = bounds.w,
			h = bounds.h,
			mode = mode,
		}
	end
end

Scrollpane.is_mouse_inside_widget = function(gui_state, scrollpane_state, mx, my)
	if not gui_state or not gui_state.input then return false end
	-- We cannot check this until the scrollpane was drawn once
	if not (scrollpane_state.transform and scrollpane_state.w and 
		    scrollpane_state.h)
	then 
		return false
	end

	return imgui.is_mouse_in_rect(gui_state, 0, 0, 
		scrollpane_state.w, scrollpane_state.h, mx, my, 
		scrollpane_state.transform)

end

Scrollpane.init_scrollpane_state = function(x, y, min_x, min_y, max_x, max_y)
	return  {
		x = x or 0, -- the x offset of the viewport
		y = y or 0, -- the y offset of the viewport
		-- If any of the following are set to nil, then the viewport's movement
		-- is not restricted.
		min_x = min_x, -- the x coordinate below which the viewport cannot be moved
		min_y = min_y, -- the y coordinate below which the viewport cannot be moved
		max_x = max_x, -- the x coordinate above which the viewport cannot be moved
		max_y = max_y, -- the y coordinate above which the viewport cannot be moved
		-- the dimensions of the scrollpane's viewport. will be updated
		-- automatically
		w = nil,
		h = nil,
		-- We need a reference to the transformation transform that is being used
		-- when the scrollpane starts.
		transform = nil,

		-- whether the scrollpane needed scrollbars in the last frame
		had_vertical = false,
		had_horizontal = false,

		-- Scrolling behavior
		tx = 0, -- target translate translation in x
    	ty = 0, -- target translate translation in y
    	last_dx = 0, -- last translate speed in x
	    last_dy = 0, -- last translate speed in y

	    -- Focus, will be applied on the next frame
	    focus = nil,
	}
end

Scrollpane.start = function(state, x, y, w, h, scrollpane_state)
	scrollpane_state = scrollpane_state or Scrollpane.init_scrollpane_state()

	assert(state)
	assert(scrollpane_state)
	x = x or state.layout.next_x
	y = y or state.layout.next_y
	w = w or state.layout.max_w
	h = h or state.layout.max_h

	-- Start a layout that contains this scrollpane
	Layout.start(state, x, y, w, h)
	love.graphics.clear(76, 100, 117)

	-- Calculate the dimension of the viewport, based on whether the viewport
	-- needed a scrollbar in the last frame
	local inner_w = w
	if scrollpane_state.had_vertical then inner_w = inner_w - scrollbar_margin end
	local inner_h = h
	if scrollpane_state.had_horizontal then inner_h = inner_h - scrollbar_margin end

	-- The scrollpane's content will not see any input unless the mouse is in
	-- the scrollpane's area
	scrollpane_state.covered_input = not imgui.is_mouse_in_rect(state, 0, 0, inner_w, inner_h)
	if scrollpane_state.covered_input then
		imgui.cover_input(state)
	end

	-- Start a layout that encloses the viewport's content
	Layout.start(state, 0, 0, inner_w, inner_h)

	-- Update the scrollpane's viewport width and height
	scrollpane_state.w = state.layout.max_w
	scrollpane_state.h = state.layout.max_h

	-- Update the scrollpane's transform transform
	scrollpane_state.transform = state.transform:clone()

	-- Apply focus if there is one
	if scrollpane_state.focus then
		apply_focus(state, scrollpane_state)
	end

	-- Note the flipped signs
	love.graphics.translate(-scrollpane_state.x, -scrollpane_state.y)

	return scrollpane_state
end

Scrollpane.finish = function(state, scrollpane_state, w, h)
	-- If the content defined advance values in x and y, we can detect whether
	-- we need to draw scroll bars at all.
	local content_w = w or state.layout.adv_x
	local content_h = h or state.layout.adv_y

	-- Finish the layout that encloses the viewport's content
	Layout.finish(state)

	if scrollpane_state.covered_input then
		imgui.uncover_input(state)
	end

	local x = state.layout.next_x
	local y = state.layout.next_y
	local w = state.layout.max_w
	local h = state.layout.max_h

	local inner_w = state.layout.max_w - (scrollpane_state.had_vertical and 
		                                  scrollbar_margin or 0)
	local inner_h = state.layout.max_h - (scrollpane_state.had_horizontal and 
		                                  scrollbar_margin or 0)

	local has_vertical = content_h > inner_h
	local has_horizontal = content_w > inner_w

	local quads = state.style.quads.scrollpane

	-- Render the vertical scrollbar if necessary
	if has_vertical then
		local height = h
		if has_horizontal then height = height - scrollbar_margin end
		-- buttons
		love.graphics.draw(state.style.stylesheet, quads.buttons.up,
			               x + w - scrollbar_margin, y)
		love.graphics.draw(state.style.stylesheet, quads.buttons.down,
			               x + w - scrollbar_margin, y + height - scrollbar_margin)

		-- scrollbar
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_v.background,
			               x + w - scrollbar_margin, y + scrollbar_margin,
			               0, 1, height - 2*scrollbar_margin)

		-- The area in which the scrollbar can be moved around
		local sb_area = height - 2*scrollbar_margin - 2
		-- The maximum scrollbar height needs to leave room for the top and
		-- bottom sprite, as well as a one pixel margin to either side
		local max_sb_height = sb_area -
		                      state.style.raw_quads.scrollpane.scrollbar_v.bottom.h -
		                      state.style.raw_quads.scrollpane.scrollbar_v.top.h
		local sb_height = math.floor((inner_h / content_h) * max_sb_height)
		sb_height = math.max(1, sb_height)

		-- Relative viewport position: 0 when the viewport shows the very
		-- beginning of the content, 1 when the viewport shows the very end of
		-- the content
		local rel_vp_pos = scrollpane_state.y / (content_h - inner_h)
		-- crop to [0, 1]
		rel_vp_pos = math.min(1, math.max(0, rel_vp_pos))

		local total_sb_height = sb_height + 
		    state.style.raw_quads.scrollpane.scrollbar_v.bottom.h +
		    state.style.raw_quads.scrollpane.scrollbar_v.top.h

		local sb_y = scrollbar_margin + 1 + rel_vp_pos * (sb_area - total_sb_height)
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_v.top,
			               x + w - scrollbar_margin, sb_y)
		sb_y = sb_y + state.style.raw_quads.scrollpane.scrollbar_v.top.h
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_v.center,
			               x + w - scrollbar_margin, sb_y, 0, 1, sb_height)
		sb_y = sb_y + sb_height
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_v.bottom,
			               x + w - scrollbar_margin, sb_y)
	end

	-- Render the horizontal scrollbar if necessary
	if has_horizontal then
		local width = w
		if has_vertical then width = width - scrollbar_margin end
		love.graphics.draw(state.style.stylesheet, quads.buttons.left,
			               x, y + h - scrollbar_margin)
		love.graphics.draw(state.style.stylesheet, quads.buttons.right,
			               x + width - scrollbar_margin, y + h - scrollbar_margin)

		-- scrollbar
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_h.background,
			               x + scrollbar_margin, y + h - scrollbar_margin,
			               0, width - 2*scrollbar_margin, 1)

		-- The area in which the scrollbar can be moved around
		local sb_area = width - 2*scrollbar_margin - 2
		-- The maximum scrollbar width needs to leave room for the left and
		-- right sprite, as well as a one pixel margin to either side
		local max_sb_width = sb_area -
		                     state.style.raw_quads.scrollpane.scrollbar_h.left.w -
		                     state.style.raw_quads.scrollpane.scrollbar_h.right.w
		local sb_width = math.floor((inner_w / content_w) * max_sb_width)
		sb_width = math.max(1, sb_width)

		-- Relative viewport position: 0 when the viewport shows the very
		-- beginning of the content, 1 when the viewport shows the very end of
		-- the content
		local rel_vp_pos = scrollpane_state.x / (content_w - inner_w)
		-- crop to [0, 1]
		rel_vp_pos = math.min(1, math.max(0, rel_vp_pos))

		local total_sb_width = sb_width + 
		    state.style.raw_quads.scrollpane.scrollbar_h.left.w +
		    state.style.raw_quads.scrollpane.scrollbar_h.right.w

		local sb_x = scrollbar_margin + 1 + rel_vp_pos * (sb_area - total_sb_width)
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_h.left,
			               sb_x, y + h - scrollbar_margin)
		sb_x = sb_x + state.style.raw_quads.scrollpane.scrollbar_h.left.w
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_h.center,
			               sb_x, y + h - scrollbar_margin, 0, sb_width, 1)
		sb_x = sb_x + sb_width
		love.graphics.draw(state.style.stylesheet, quads.scrollbar_h.right,
			               sb_x, y + h - scrollbar_margin)
	end

	-- Render the little corner if we have both a vertical and horizontal
	-- scrollbar
	if has_vertical and has_horizontal then
		love.graphics.draw(state.style.stylesheet, quads.buttons.corner,
			               x + w - scrollbar_margin, y + h - scrollbar_margin)
	end

	scrollpane_state.had_vertical = has_vertical
	scrollpane_state.had_horizontal = has_horizontal

	if state and state.input then
		handle_input(state, scrollpane_state, w, h)
	end

	-- Image panning
	local friction = 0.5

	-- Gently pan to target position
	local dx = friction * (scrollpane_state.tx - scrollpane_state.x)
	local dy = friction * (scrollpane_state.ty - scrollpane_state.y)

	-- Apply the translation change
	move_viewport_within_bounds(scrollpane_state, dx, dy)

	-- Remember the last delta to possibly trigger floating in the next frame
	scrollpane_state.last_dx = dx
	scrollpane_state.last_dy = dy

	-- This layout always fills the available space
	state.layout.adv_x = state.layout.max_w
	state.layout.adv_y = state.layout.max_h
	Layout.finish(state)
end

return Scrollpane