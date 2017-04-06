-- Module that contains all strings that are used in the application

local function f(str)
  return function(...)
    return string.format(str, ...)
  end
end

local function menu_table(menu_string, table)
  return setmetatable(table,{__call = function() return menu_string end})
end

-- Strips single new-lines and whitespace after a newline. This makes it easier
-- to embed text in this file without inserting unwanted newlines and whitespace.
local function s(str)
  return string.gsub(str, "\n[ \t]+", " ")
end

local strings = {}

strings.github_url = "https://www.github.com/25A0/Quadtastic"
strings.report_email = "moritz@25a0.com"

strings.toast = {
  saved_as = f "Saved as %s",
  reloaded = f "Reloaded %s",
}

strings.menu = {
  file = menu_table("File", {
      new = "New",
      open = "Open...",
      save = "Save",
      save_as = "Save as...",
      open_recent = "Open recent",
      quit = "Quit",
    }),
  edit = menu_table("Edit", {
      undo = "Undo",
      redo = "Redo",
    }),
  image  = menu_table("Image", {
      open_image = "Open image...",
      reload_image = "Reload image",
    }),
  help = menu_table("Help", {
      github = "GitHub",
      report = menu_table("Report a bug", {
          github = "via GitHub",
          email = "via email",
          email_subject = f "Bug in Quadtastic %s",
          issue_body = function(version_info)
            -- luacheck: ignore 613
            local issuebody = [[
[Describe the bug]

### Steps to reproduce
 1. 

###  Expected behaviour


### Actual behaviour :scream:


---
Affects: %s]]
            issuebody = string.format(issuebody, version_info)
            issuebody = string.gsub(issuebody, "\n", "%%0A")
            issuebody = string.gsub(issuebody, " ", "%%20")
            issuebody = string.gsub(issuebody, "#", "%%23")
            return issuebody
          end,
        }),
      acknowledgements = "Acknowledgements",
      about = "About",
    }),
}

strings.tooltips = {
  select_tool = "Select, move and resize quads",
  create_tool = "Create new quads",
  border_tool = "Create quads for a border",
  strip_tool = "Create a strip of similar quads",
  zoom_in = "Zoom in",
  zoom_out = "Zoom out",
  turbo_workflow = s[[Reloads image whenever it changes on disk, and repeats
                      export whenever quads change.]],
  rename = "Rename",
  delete = "Delete selected quad(s)",
  sort = "Sort unnamed quads from top to bottom, left to right",
  group = "Form new group from selected quads",
  ungroup = "Break up selected group(s)",
}

strings.image_editor_no_image = s[[no image :(

                                   Drag an image into this window to load it]]

strings.buttons = {
  export = "EXPORT",
  yes = "Yes",
  no = "No",
  cancel = "Cancel",
  ok = "OK",
  swap = "Swap",
  replace = "Replace",
  save = "Save",
  discard = "Discard",
  open = "Open",
  close = "Close",
}

strings.dialogs = {
  quit = "Do you really want to quit?",
  rename = {
    err_only_one = "You cannot rename more than one element at once.",
    err_nested_quad = f(s("The element %s is a quad, and can therefore not have\
                           nested quads.")),
    err_exists = f "The element '%s' already exists.",
    name_prompt = "Name:",
  },
  sort = {
    err_not_shared_group = "You cannot sort quads across different groups",
    err_no_numeric_quads = "Only unnamed quads can be sorted",
  },
  group = {
    err_not_shared_group = "You cannot group quads across different groups",
  },
  ungroup = {
    err_only_one = "You can only break up one group at a time",
    warn_numeric_clash = f(s[[Breaking up this group will change some numeric
                             indices of the elements in that group. In particular,
                             the index %d already exists in the parent group.

                             Proceed anyways?]]),
    err_name_conflict = f(s[[This group cannot be broken up since there is
                             already an element called '%s'.]]),
  },
  offer_reload = f(s[[The image %s has changed on disk.

                      Do you want to reload it?]]),
  save_changes = "Do you want to save the changes you made in the current file?",
  err_load_quads = f "Could not load quads: %s",
  err_load_image = f "Could not load image: %s",
  offer_load = "We found a quad file in %s.\nWould you like to load it?",
  err_save_directory = f "%s is a directory.",
  save_replace = f "File %s already exists. Do you want to replace it?",
  about = f "Quadtastic %s",
  acknowledgements = "Quadtastic uses the following open-source software projects:",
}


return strings