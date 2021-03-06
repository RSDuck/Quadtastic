## Changelog

### Planned

### Unreleased

There are currently no unreleased changes

### Release 0.6.4, 2017-11-01

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.6.4)

 - Fix a bunch of bugs related to saving and exporting ([#35](https://github.com/25A0/Quadtastic/issues/35))

### Release 0.6.3, 2017-09-26

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.6.3)

 - Add snapping to grid. See [this wiki page](/wiki/Using-Quadtastic.md#grid) for more information
 - Fix an issue where files would be listed out of alphabetic order on some
   file systems
 - Fix the reason why double-clicking an element to rename it only worked for
   top-level quads and groups ([#29](https://github.com/25A0/Quadtastic/issues/29))
 - Reserved Lua keywords can now be used as names for quads and groups
   ([#27](https://github.com/25A0/Quadtastic/issues/27))
 - The wiki has moved to https://github.com/25A0/Quadtastic/blob/master/wiki ([#26](https://github.com/25A0/Quadtastic/issues/26))
 - Fix a crash ([#31](https://github.com/25A0/Quadtastic/issues/31))

### Release 0.6.2, 2017-08-23

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.6.2)

Just a smol macOS bugfix.

 - (macOS) Quadtastic will no longer be listed under apps that can open .love archives

### Release 0.6.1, 2017-07-28

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.6.1)

 - Fix crash in initialization of default exporters in binary distributions

### Release 0.6.0, 2017-07-28

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.6.0)

 - Add custom exporters. Custom exporters can be used to export quad definitions
   to formats other than the default quad file used by Quadtastic. There are
   default exporters for JSON and XML, but you can also write your own exporter,
   or use an exporter from the community. Documentation for writing exporters is
   available in the wiki on GitHub (https://github.com/25A0/Quadtastic/wiki).
 - When Turbo-Workflow is enabled, not only will the quad file be saved whenever
   quads change, but now the last export will be repeated, too.
 - Use <kbd>ctrl+e</kbd> or <kbd>cmd+e</kbd> to repeat the previous export
 - The reference to the image is now stored as a relative path in the quad
   file, so that quad files can be loaded on different computers without hassle
 - Double-click a quad or group in the quad list to rename it
 - On Windows and Linux, scroll horizontally when shift is pressed
 - Fix slow scrolling on Linux and Windows
 - Capture output in a log file `log.txt`. This file can be found in:
    - `%appdata%\Quadtastic\`                      on Windows,
    - `~/Library/Application\ Support/Quadtastic/` on macOS,
    - `~/.local/share/love/`                       on Linux
 - Fix a bug where changing directories in the file browser would not reset the
   file list to the beginning

### Release 0.5.3, 2017-05-02

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.5.3)

 - Crash reports now contain the full stack trace
 - Fix crash related to rendering non-utf8 encoded characters

### Release 0.5.2, 2017-04-21

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.5.2)

Small update to collect error messages on crash

 - Display toast that image was reloaded when user reloads manually from menu
 - Ask user to report error message when Quadtastic crashes

### Release 0.5.1, 2017-04-20

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.5.1)

 - Notify user when a new version is available

### Release 0.5.0, 2017-04-19

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.5.0)

First public release

 - Quadfiles are saved with a neat, compact layout again where possible
 - Add wand tool to create quads from opaque areas
 - Lower minimum zoom level for bigger sprite sheets
 - Fix opened menu items not being highlighted
 - Show keybindings in menus and tooltips
 - Add palette tool that creates a quad for each unique color in the
   selected region
 - Grouping quads now preserves the order of quads with numeric indices
 - Sample palette color from center of quad instead of upper left corner
 - Show a bright pixel under the cursor when using the wand tool
 - When grouping quads, select the newly created group
 - Add separate items for documentation and source code to help menu
 - Make sure that importing palettes will still work in LOVE 0.11
 - Add Makefile target to push builds to itch.io
 - Add license to libquadtastic since it will likely be used separately from
   the rest of the codebase
 - Add menu item to copy current libquadtastic version to clipboard
 - Add example project
 - Add libquadtastic as distribution target
 - Add version number to quadfile

### Release 0.4.1, 2017-04-08

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.4.1)

 - Remove roadmap from README and keep track of changes in changelog.md

### Release 0.4.0, 2017-04-08

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.4.0)

 - Distribution:
    - Windows 32 bit
    - Linux (works if lfs is installed with luarocks)
 - Outline quads in black and white for better contrast
 - Fix detection of quads: Currently the application treats all tables as
   quads that have values for x, y, w, and h. This means that you cannot
   have a group that contains the entire alphabet, since that group could
   have quads named x, y, w and h. Solution: Make sure that the values of
   the x, y, w and h attributes are numeric.
 - Fix error handling when image cannot be loaded
 - Colors in Palette are callable tables to easily change the alpha values
 - Improve hitbox size to make it easier to move small quads around
 - When saving, add a default extension when the user doesn't specify one
 - When renaming quads, treat numbers as numeric indices
 - When saving for the first time, open file browser at location of loaded image

### Release 0.3.0, 2017-04-06

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.3.0)

 - Add About dialog
 - Add menu to help users report bugs easily via GitHub or email
 - Add License (MIT)
 - Add acknowledgement dialog with licenses of used software
 - Show confirmation dialog when the user would lose changes by loading a
   new image or quad file
 - Add line under image editor to let user know that they can drag images
   onto the window to load it
 - Undo/Redo history
 - Allow user to drag .qua file onto window
 - Move all text to separate module for better readability, easier
   localization, and easy comparison during tests
 - Turbo-Workflow
     - Automatically reload image when it changes on disk
     - Automatically export new quad file whenever quads are changed

### Release 0.2.0, 2017-03-29

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.2.0)

 - Selectable text in input fields
 - Select all text when editing quad name
 - Use common keys (Return, ESC) to confirm or cancel dialogs
 - Use Esc to clear selection of text or elements
 - Resize dialogs automatically so that they use up as little space as possible
 - Automatically generate change log from checked items
   in README's Roadmap. Most of the time it works every time!
 - Automatically put version and commit hash in plist
 - Icon
 - Show Quadtastic in title bar
 - Makefile recipe for tagging releases
 - Detect when an image changed on disk
 - Select newly created quads to speed up workflow
 - Add new quads to currently selected group, or to group of currently
 - Keybindings to rename, delete, open, save etc.
 - Add metadata to qua file to remember which image was loaded along with it
 - Adjust center of the viewport after zooming
 - Add file browser
 - Add background to text drawn next to mouse cursor for better readability
 - Add "Toast"-like feature for things like successful saving
 - Show a "Saved" toast when the quads were written to disk successfully
 - Show size of currently drawn quad next to mouse cursor
 - Show cursors position in status bar
 - Save recently opened file and show them in menu
 - Idle application while not in focus
 - Resize overlay canvas on resize, otherwise things might break subtly
 - Add text area that wraps at layout boundary automatically
 - The Create tool to create new quads
 - The Select tool to select, move and resize quads
 - Export quads in consistent order. The previous export method was somewhat
   random, which causes the output to change even if the quad definitions
   stayed the same

### Release 0.1.0, 2017-03-20

First versioned commit.

[Download](https://github.com/25A0/Quadtastic/releases/tag/0.1.0)

Features implemented so far:

 - Select a file
 - Load the image
 - Display the image
 - zoom and move the image around
 - Define quads
 - Name quads
 - Delete and modify existing quads
 - Export defined quads as lua code
 - Detect and import existing quad definitions
 - Group quads
 - Highlight selected and hovered quads
 - Display name of quads in ImageEditor
 - Use dot notation in quad names to move them to quad groups
 - Scroll quad list viewport to created or modified quad
 - Scroll image editor viewport to clicked quad
 - Fix scroll bars not displaying in image editor
 - Implement scroll bars
 - Use CTRL+Mousewheel to zoom
 - Use MMB to pan image
 - Make quad groups in quad list collapsible and expandable
