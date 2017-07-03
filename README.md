<h1 align="center">Quadtastic!</h1>

<p align="center">
  A simple standalone tool to manage sprite sheets and color palettes for
  <a href="https://www.love2d.org">LÖVE</a> projects.
</p>

<p align="center">
  <img src="screenshots/screenshot.png" alt="Screenshot of Quadtastic">
</p>

<p align="center">
  <a href="https://25a0.itch.io/quadtastic">
    <img src="res/download.png" alt="Download on itch.io">
  </a>
</p>

<p align="center">
  <a href="https://github.com/25a0/Quadtastic/wiki">
    <img src="http://imgur.com/Kkquk1h.png" alt="Documentation">
  </a>
</p>

## Features

 - Create quads straight on your spritesheet -- no need to ever type out coordinates again
 - Keep your quads neatly organized by giving them descriptive names and grouping them
 - Move and resize existing quads
 - Use the wand tool to create quads from opaque areas automatically
 ![Using the wand tool](screenshots/wand.gif)
 - Use the palette tool to create quads from areas that have the same color
 ![Using the palette tool](screenshots/palette.gif)
 - Learn more about how to [**use Quadtastic**](https://github.com/25a0/Quadtastic/wiki/Using-Quadtastic)
 - Save quads as a simple lua table.
   As you expand your sprite sheet, you can re-open this file in Quadtastic
   to add or modify quads.
   You can also [export your quads](https://github.com/25A0/Quadtastic/wiki/Exporters) to JSON or XML.
```lua
return {
  base = {x = 16, y = 27, w = 16, h = 8},
  bubbles = {
    {x = 2, y = 18, w = 5, h = 5},
    {x = 1, y = 25, w = 3, h = 4},
    {x = 10, y = 18, w = 5, h = 3},
    {x = 7, y = 24, w = 7, h = 6},
    {x = 3, y = 8, w = 5, h = 4},
    {x = 10, y = 11, w = 4, h = 3},
    {x = 7, y = 3, w = 6, h = 4},
  },
  lid = {x = 16, y = 7, w = 16, h = 15},
  liquid = {x = 0, y = 32, w = 3, h = 3},
  stand = {x = 32, y = 32, w = 16, h = 16},
}
 ```
 - Enable ![Turbo Workflow](screenshots/turboworkflow.gif) to reload the
   spritesheet whenever it changes on disk, and to re-export the quads whenever
   you change them
 - In your LÖVE project, turn these quads into LÖVE Quad objects with just a
   few lines of code
```lua
  -- load the raw quad definitions that you created with Quadtastic
  local raw_quads = require("res/quads")
  image = love.graphics.newImage("res/sheet.png") -- load spritesheet

  -- Create LÖVE Quads from raw quad definitions
  quads = libquadtastic.create_quads(raw_quads, image:getWidth(), image:getHeight())
```
 - You can then draw these quads like so:
```lua
  love.graphics.draw(image, quads.base)
```

 - Learn more about how to [**use quads and palettes in your LÖVE project**](https://github.com/25a0/Quadtastic/wiki/Using-quads-and-palettes)

## Binary downloads

You can find executables of Quadtastic for Windows and OS X [on itch.io](https://25a0.itch.io/quadtastic), as well as a cross-platform `.love` archive.

While the executable versions should run out of the box, **the `.love` version
requires [LuaFileSystem](keplerproject.github.io/luafilesystem/)**.
If you have [luarocks](https://luarocks.org/) installed, you can install LuaFileSystem with
```
  luarocks install luafilesystem
```

## Running Quadtastic from source

If you prefer to run Quadtastic from source, here is what you'll need to do

 1. Install [LÖVE](https://www.love2d.org), and make `love` available on your path
 2. **On linux**, install luafilesystem if not already installed,
    e.g. with `luarocks install luafilesystem`.
    (On Windows and MacOS, Quadtastic will use the compiled version of
     luafilesystem that is included in this repo)
 3. Clone this repository, e.g. with `git clone git@github.com:25a0/Quadtastic.git`
 4. `cd Quadtastic/`
 5. If you have Gnu Make, run `make app_resources`.
    If you don't, you can skip this step, but you won't see the correct version
    number.
 6. `love Quadtastic`


## [Changelog](./changelog.md)

## Credits and tools used

 - [LÖVE](https://love2d.org/)
 - The [m5x7](https://managore.itch.io/m5x7) and [m3x6](https://managore.itch.io/m3x6)
   fonts by Daniel Linssen
 - [aseprite](https://www.aseprite.org/) by David Kapello.
   Oh, also, the pixelated Quadtastic UI is my lousy attempt to create something
   similar to the gorgeous UI in aseprite.
 - [luafilesystem](https://github.com/keplerproject/luafilesystem)
 - [lovedebug](https://github.com/Ranguna/LOVEDEBUG) by kalle2990, maintained by Ranguna
 - [Nuklear](https://github.com/vurtun/nuklear) for guidance on how to write IMGUI
 - affine for reverse transformation by [Minh Ngo](https://github.com/markandgo/simple-transform)
 - xform by [pgimeno](https://love2d.org/forums/viewtopic.php?p=201884#p201884)
   for practical ideas related to reverse transformation
