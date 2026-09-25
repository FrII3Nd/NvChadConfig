-- nvim-light: реплика темы "Nvim Light" с https://cmuxthemes.com/themes/nvim-light/
-- Исходная палитра (cmux / terminal ANSI):
--   fg #14161b  bg #e0e2ea  cursor #9b9ea4
--   0 #07080d  1 #590008  2 #005523  3 #6b5300
--   4 #004c73  5 #470045  6 #007373  7 #a1a4ab
--   8 #4f5258  9 #590008 10 #005523 11 #6b5300
--  12 #004c73 13 #470045 14 #007373 15 #eef1f8
-- Тема светлая, высококонтрастная: тёмные насыщенные акценты на холодном
-- светло-лавандовом фоне. Роли токенов повторяют превью на сайте:
-- keyword = magenta, function = blue, string = yellow, number = red,
-- type = cyan, comment = dark grey.

local M = {}

-- UI-цвета (фон, панели, статуслайн, скроллбары и т.п.)
M.base_30 = {
  white = "#14161b", -- основной цвет текста (fg)
  darker_black = "#d9dce5", -- фон плавающих окон
  black = "#e0e2ea", -- основной фон редактора (bg)
  black2 = "#d3d7e1", -- чуть темнее фона (CursorLine, ColorColumn)
  one_bg = "#ccd0db",
  one_bg2 = "#c3c8d5",
  one_bg3 = "#bac0ce",
  grey = "#a1a4ab", -- номера строк (color7 / cursor)
  grey_fg = "#4f5258", -- комментарии (color8)
  grey_fg2 = "#5c6068",
  light_grey = "#4f5258",
  red = "#590008", -- color1 / color9
  baby_pink = "#470045",
  pink = "#470045", -- color5
  line = "#c6cbd7", -- разделители окон
  green = "#005523", -- color2
  vibrant_green = "#007373",
  blue = "#004c73", -- color4
  nord_blue = "#004c73",
  yellow = "#6b5300", -- color3
  sun = "#8b6d00",
  purple = "#470045",
  dark_purple = "#350033",
  teal = "#007373", -- color6
  orange = "#8b4c00", -- в исходной палитре нет; осветлённый тёплый акцент
  cyan = "#007373",
  statusline_bg = "#d9dce5",
  lightbg = "#ccd0db",
  pmenu_bg = "#9b9ea4",
  folder_bg = "#4f5258",
}

-- Цвета синтаксиса (base16-раскладка), подобраны под роли из превью темы
M.base_16 = {
  base00 = "#e0e2ea", -- фон
  base01 = "#e8eaf1", -- светлее фона (статуслайн, номера строк, фолдинг)
  base02 = "#cbd0dc", -- фон выделения
  base03 = "#4f5258", -- комментарии, невидимые символы
  base04 = "#9b9ea4", -- тёмный fg (статусбары)
  base05 = "#14161b", -- текст по умолчанию (fg)
  base06 = "#0d0e13",
  base07 = "#07080d", -- самый тёмный (color0)
  base08 = "#590008", -- переменные, diff deleted, операторы-идентификаторы
  base09 = "#590008", -- числа, константы, boolean
  base0A = "#007373", -- типы, теги, preproc
  base0B = "#6b5300", -- строки, diff inserted
  base0C = "#005523", -- special, regex, escape
  base0D = "#004c73", -- функции, методы, заголовки
  base0E = "#470045", -- ключевые слова
  base0F = "#4f5258", -- пунктуация, deprecated
}

-- Мягкая доводка отдельных групп под высокий контраст темы
M.polish_hl = {
  defaults = {
    Comment = { fg = M.base_30.grey_fg, italic = true },
    CursorLine = { bg = M.base_30.black2 },
    Visual = { bg = M.base_16.base02 },
    Search = { fg = M.base_16.base01, bg = M.base_30.sun },
    IncSearch = { fg = M.base_16.base01, bg = M.base_30.orange },
    LineNr = { fg = M.base_30.grey },
    CursorLineNr = { fg = M.base_30.blue, bold = true },
  },

  treesitter = {
    ["@comment"] = { fg = M.base_30.grey_fg, italic = true },
    ["@punctuation.bracket"] = { fg = M.base_16.base05 },
    ["@punctuation.delimiter"] = { fg = M.base_16.base05 },
    ["@operator"] = { fg = M.base_16.base05 },
  },

  telescope = {
    TelescopeSelection = { bg = M.base_30.one_bg, fg = M.base_30.white },
    TelescopePromptPrefix = { fg = M.base_30.blue },
  },

  statusline = {
    St_pos_text = { fg = M.base_30.white },
  },
}

M.type = "light"

-- Позволяет точечно переопределять тему из chadrc.base46.changed_themes
M = require("base46").override_theme(M, "nvim-light")

return M
