return {
  background = {x = 48, y = 16, w = 8, h = 8},
  rowbackground = {
    expanded = {
      hovered = {x = 10, y = 32, w = 7, h = 7},
      default = {x = 17, y = 32, w = 7, h = 7},
      pressed = {x = 3, y = 32, w = 7, h = 7},
    },
    hovered = {
      center = {x = 1, y = 34, w = 1, h = 1},
      bottom = {x = 1, y = 46, w = 1, h = 2},
      top = {x = 1, y = 32, w = 1, h = 2},
    },
    selected = {
      bottom = {x = 2, y = 46, w = 1, h = 2},
      center = {x = 2, y = 34, w = 1, h = 1},
      top = {x = 2, y = 32, w = 1, h = 2},
    },
    collapsed = {
      hovered = {x = 10, y = 40, w = 7, h = 7},
      default = {x = 17, y = 40, w = 7, h = 7},
      pressed = {x = 3, y = 40, w = 7, h = 7},
    },
    default = {
      bottom = {x = 0, y = 46, w = 1, h = 2},
      center = {x = 0, y = 34, w = 1, h = 1},
      top = {x = 0, y = 32, w = 1, h = 2},
    },
  },
  frame_border = {
    t = {x = 50, y = 0, w = 1, h = 2},
    tl = {x = 48, y = 0, w = 2, h = 2},
    br = {x = 62, y = 14, w = 2, h = 2},
    b = {x = 50, y = 14, w = 1, h = 2},
    bl = {x = 48, y = 14, w = 2, h = 2},
    tr = {x = 62, y = 0, w = 2, h = 2},
    c = {x = 50, y = 2, w = 1, h = 1},
    l = {x = 48, y = 2, w = 2, h = 1},
    r = {x = 62, y = 2, w = 2, h = 1},
  },
  menu = {
    t = {x = 98, y = 32, w = 1, h = 2},
    arrow = {x = 96, y = 41, w = 7, h = 7},
    bl = {x = 96, y = 35, w = 2, h = 2},
    tr = {x = 110, y = 32, w = 2, h = 2},
    tl = {x = 96, y = 32, w = 2, h = 2},
    br = {x = 110, y = 35, w = 2, h = 2},
    b = {x = 98, y = 35, w = 1, h = 2},
  },
  buttons = {
    delete = {x = 96, y = 64, w = 13, h = 13},
    sort = {x = 112, y = 64, w = 13, h = 13},
    group = {x = 96, y = 48, w = 13, h = 13},
    rename = {x = 48, y = 64, w = 13, h = 13},
    plus = {x = 64, y = 0, w = 5, h = 5},
    ungroup = {x = 112, y = 48, w = 13, h = 13},
    minus = {x = 69, y = 0, w = 5, h = 5},
  },
  tooltip = {
    border = {
      t = {x = 2, y = 48, w = 1, h = 2},
      tl = {x = 0, y = 48, w = 2, h = 2},
      c = {x = 2, y = 50, w = 1, h = 1},
      b = {x = 2, y = 51, w = 1, h = 2},
      bl = {x = 0, y = 51, w = 2, h = 2},
      r = {x = 3, y = 50, w = 2, h = 1},
      tr = {x = 3, y = 48, w = 2, h = 2},
      l = {x = 0, y = 50, w = 2, h = 1},
      br = {x = 3, y = 51, w = 2, h = 2},
    },
    tip = {
      downwards = {x = 5, y = 48, w = 7, h = 3},
      upwards = {x = 5, y = 50, w = 7, h = 3},
    },
  },
  input_field_border = {
    t = {x = 3, y = 16, w = 1, h = 3},
    tl = {x = 0, y = 16, w = 3, h = 3},
    br = {x = 29, y = 29, w = 3, h = 3},
    b = {x = 3, y = 29, w = 1, h = 3},
    bl = {x = 0, y = 29, w = 3, h = 3},
    tr = {x = 29, y = 16, w = 3, h = 3},
    c = {x = 3, y = 19, w = 1, h = 1},
    l = {x = 0, y = 19, w = 3, h = 1},
    r = {x = 29, y = 19, w = 3, h = 1},
  },
  window_border = {
    t = {x = 87, y = 32, w = 1, h = 7},
    tl = {x = 80, y = 32, w = 7, h = 7},
    br = {x = 89, y = 41, w = 7, h = 7},
    b = {x = 87, y = 41, w = 1, h = 7},
    bl = {x = 80, y = 41, w = 7, h = 7},
    tr = {x = 89, y = 32, w = 7, h = 7},
    c = {x = 87, y = 39, w = 1, h = 1},
    l = {x = 80, y = 39, w = 7, h = 1},
    r = {x = 89, y = 39, w = 7, h = 1},
  },
  scrollpane = {
    scrollbar_v = {
      center = {x = 105, y = 3, w = 7, h = 1},
      bottom = {x = 105, y = 4, w = 7, h = 2},
      background = {x = 105, y = 0, w = 7, h = 1},
      top = {x = 105, y = 1, w = 7, h = 2},
    },
    buttons = {
      right = {
        hovered = {x = 121, y = 0, w = 7, h = 7},
        default = {x = 96, y = 0, w = 7, h = 7},
        pressed = {x = 121, y = 16, w = 7, h = 7},
      },
      left = {
        hovered = {x = 121, y = 9, w = 7, h = 7},
        default = {x = 96, y = 9, w = 7, h = 7},
        pressed = {x = 121, y = 25, w = 7, h = 7},
      },
      down = {
        hovered = {x = 112, y = 9, w = 7, h = 7},
        pressed = {x = 112, y = 25, w = 7, h = 7},
        default = {x = 80, y = 9, w = 7, h = 7},
      },
      up = {
        hovered = {x = 112, y = 0, w = 7, h = 7},
        default = {x = 80, y = 0, w = 7, h = 7},
        pressed = {x = 112, y = 16, w = 7, h = 7},
      },
    },
    corner = {x = 105, y = 9, w = 7, h = 7},
    scrollbar_h = {
      right = {x = 109, y = 0, w = 2, h = 7},
      left = {x = 106, y = 0, w = 2, h = 7},
      center = {x = 108, y = 0, w = 1, h = 7},
      background = {x = 105, y = 0, w = 1, h = 7},
    },
  },
  button_border = {
    t = {x = 3, y = 0, w = 1, h = 3},
    tl = {x = 0, y = 0, w = 3, h = 3},
    br = {x = 29, y = 13, w = 3, h = 3},
    b = {x = 3, y = 13, w = 1, h = 3},
    bl = {x = 0, y = 13, w = 3, h = 3},
    r = {x = 29, y = 3, w = 3, h = 1},
    tr = {x = 29, y = 0, w = 3, h = 3},
    l = {x = 0, y = 3, w = 3, h = 1},
    c = {x = 3, y = 3, w = 1, h = 1},
  },
}
