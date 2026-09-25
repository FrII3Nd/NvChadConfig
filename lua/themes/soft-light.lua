-- soft-light: тёплая «бумажная» светлая тема с низким контрастом.
-- Находится в личной папке тем, поэтому появляется во встроенном
-- theme selector NvChad (<leader>th) рядом со встроенными темами base46.

local M = {}

-- UI-цвета (общий фон, панели, статуслайн, скроллбары и т.п.)
M.base_30 = {
  white = "#3b3a37", -- основной цвет текста
  darker_black = "#efece7", -- фон плавающих окон
  black = "#f7f5f2", -- основной фон редактора
  black2 = "#edeae4", -- чуть темнее фона (CursorLine, ColorColumn)
  one_bg = "#e7e3dc",
  one_bg2 = "#ded9d1",
  one_bg3 = "#d4cec5",
  grey = "#b9b2a7", -- номера строк
  grey_fg = "#a9a296",
  grey_fg2 = "#9b9488",
  light_grey = "#8c8578", -- комментарии
  red = "#c14a4a",
  baby_pink = "#d98a8a",
  pink = "#c76b98",
  line = "#e2ddd5", -- разделители окон
  green = "#6a8f4e",
  vibrant_green = "#4f9e8f",
  blue = "#4a7fb5",
  nord_blue = "#4a7fb5",
  yellow = "#c08a2e",
  sun = "#d9a441",
  purple = "#8a6fb0",
  dark_purple = "#6f5a94",
  teal = "#4f9e8f",
  orange = "#c96a3a",
  cyan = "#4f9e9e",
  statusline_bg = "#efece7",
  lightbg = "#e7e3dc",
  pmenu_bg = "#6b6459",
  folder_bg = "#8a8377",
}

-- Цвета синтаксиса (base16-раскладка)
M.base_16 = {
  base00 = "#f7f5f2", -- фон
  base01 = "#efece7",
  base02 = "#e8ddd5", -- выделение
  base03 = "#b9b2a7", -- невидимые символы
  base04 = "#8c8578",
  base05 = "#3b3a37", -- текст по умолчанию
  base06 = "#2e2d2b",
  base07 = "#242322",
  base08 = "#c14a4a", -- переменные, diff deleted
  base09 = "#c96a3a", -- числа, константы
  base0A = "#8a6fb0", -- классы, поиск
  base0B = "#6a8f4e", -- строки, diff inserted
  base0C = "#4f9e9e", -- regex, escape
  base0D = "#4a7fb5", -- функции, заголовки
  base0E = "#8a6fb0", -- ключевые слова
  base0F = "#6f5a94", -- deprecated
}

-- Мягкая полировка отдельных групп, чтобы глазам было комфортнее.
M.polish_hl = {
  defaults = {
    Comment = { fg = M.base_30.light_grey, italic = true },
    CursorLine = { bg = M.base_30.black2 },
    Visual = { bg = M.base_30.one_bg2 },
    Search = { fg = M.base_30.white, bg = M.base_30.sun },
    IncSearch = { fg = M.base_30.white, bg = M.base_30.orange },
    LineNr = { fg = M.base_30.grey },
    CursorLineNr = { fg = M.base_30.orange, bold = true },
  },

  treesitter = {
    ["@punctuation.bracket"] = { fg = M.base_30.blue },
    ["@variable.builtin"] = { fg = M.base_30.red },
    ["@property"] = { fg = M.base_30.teal },
    ["@keyword"] = { fg = M.base_30.purple },
  },

  telescope = {
    TelescopeSelection = { bg = M.base_30.one_bg, fg = M.base_30.white },
    TelescopePromptPrefix = { fg = M.base_30.orange },
  },

  statusline = {
    St_pos_text = { fg = M.base_30.white },
  },
}

M.type = "light"

-- Даёт возможность точечно переопределять тему из chadrc.base46.changed_themes
M = require("base46").override_theme(M, "soft-light")

return M
