-- mono-light: светлая монохромная тема — только градации серого, без оттенков.
-- Различимость токенов обеспечивается светлотой + начертанием:
--   ключевые слова — самый тёмный и жирный,
--   функции — тёмный, типы/параметры — курсив,
--   строки — серый, комментарии — самый светлый и курсив.
-- Диагностики остаются серыми, но разной темноты (важно: при монохроме
-- ошибки/предупреждения не разноцветные — см. примечание в ответе).

local M = {}

-- UI-цвета (фон, панели, статуслайн, скроллбары и т.п.)
M.base_30 = {
  white = "#1a1a1a", -- основной цвет текста (fg)
  darker_black = "#f3f3f3", -- фон плавающих окон
  black = "#fafafa", -- основной фон редактора
  black2 = "#efefef", -- чуть темнее фона (CursorLine, ColorColumn)
  one_bg = "#e9e9e9",
  one_bg2 = "#e2e2e2",
  one_bg3 = "#dadada",
  grey = "#a8a8a8", -- номера строк
  grey_fg = "#7a7a7a", -- комментарии
  grey_fg2 = "#6b6b6b",
  light_grey = "#7a7a7a",
  red = "#3f3f3f", -- ошибки / diff deleted / git удалённое
  baby_pink = "#8f8f8f",
  pink = "#8f8f8f",
  line = "#e4e4e4", -- разделители окон
  green = "#5f5f5f", -- diff added / git добавленное
  vibrant_green = "#6b6b6b",
  blue = "#2e2e2e", -- статуслайн username / директории
  nord_blue = "#2e2e2e",
  yellow = "#4a4a4a", -- изменённое / предупреждения
  sun = "#5a5a5a",
  purple = "#3a3a3a",
  dark_purple = "#2b2b2b",
  teal = "#666666",
  orange = "#4f4f4f",
  cyan = "#707070",
  statusline_bg = "#f3f3f3",
  lightbg = "#e9e9e9",
  pmenu_bg = "#cfcfcf",
  folder_bg = "#6b6b6b",
}

-- Цвета синтаксиса (base16-раскладка) — единая серая шкала от тёмного к светлому
M.base_16 = {
  base00 = "#fafafa", -- фон
  base01 = "#f3f3f3", -- светлее фона (статуслайн, фолдинг)
  base02 = "#e6e6e6", -- фон выделения
  base03 = "#7a7a7a", -- комментарии, невидимые символы
  base04 = "#a8a8a8", -- тёмный fg (статусбары)
  base05 = "#1a1a1a", -- текст по умолчанию (fg / переменные)
  base06 = "#111111",
  base07 = "#0a0a0a", -- самый тёмный
  base08 = "#333333", -- переменные, параметры, diff deleted
  base09 = "#4a4a4a", -- числа, константы, boolean
  base0A = "#3d3d3d", -- типы, классы, теги
  base0B = "#5a5a5a", -- строки, diff inserted
  base0C = "#666666", -- special, regex, escape
  base0D = "#2e2e2e", -- функции, методы, заголовки
  base0E = "#1a1a1a", -- ключевые слова (самый контрастный)
  base0F = "#8a8a8a", -- пунктуация, deprecated
}

-- Начертание вместо цвета: так монохром остаётся различимым
M.polish_hl = {
  defaults = {
    Comment = { fg = M.base_30.grey_fg, italic = true },
    Keyword = { fg = M.base_16.base0E, bold = true },
    CursorLine = { bg = M.base_30.black2 },
    Visual = { bg = M.base_16.base02 },
    Search = { bg = M.base_30.grey, fg = M.base_30.white },
    IncSearch = { bg = M.base_30.white, fg = M.base_16.base00 },
    LineNr = { fg = M.base_30.grey },
    CursorLineNr = { fg = M.base_30.white, bold = true },
  },

  treesitter = {
    ["@comment"] = { fg = M.base_30.grey_fg, italic = true },
    ["@keyword"] = { fg = M.base_16.base0E, bold = true },
    ["@keyword.function"] = { fg = M.base_16.base0E, bold = true },
    ["@keyword.return"] = { fg = M.base_16.base0E, bold = true },
    ["@function"] = { fg = M.base_16.base0D, bold = true },
    ["@function.call"] = { fg = M.base_16.base0D, bold = true },
    ["@function.method"] = { fg = M.base_16.base0D, bold = true },
    ["@type"] = { fg = M.base_16.base0A, italic = true },
    ["@type.builtin"] = { fg = M.base_16.base0A, italic = true },
    ["@constructor"] = { fg = M.base_16.base0A, italic = true },
    ["@variable.parameter"] = { fg = M.base_16.base08, italic = true },
    ["@property"] = { fg = M.base_16.base08 },
    ["@punctuation.bracket"] = { fg = M.base_16.base0F },
    ["@punctuation.delimiter"] = { fg = M.base_16.base0F },
  },

  telescope = {
    TelescopeSelection = { bg = M.base_30.one_bg, fg = M.base_30.white },
    TelescopePromptPrefix = { fg = M.base_30.grey_fg },
  },

  statusline = {
    St_pos_text = { fg = M.base_30.white },
  },
}

M.type = "light"

-- Позволяет точечно переопределять тему из chadrc.base46.changed_themes
M = require("base46").override_theme(M, "mono-light")

return M
