-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}
M.ui = {
  theme = "mono-light", 
}
M.base46 = {
	theme = "mono-light",

	-- Включаем интеграцию semantic_tokens (по умолчанию в base46 выключена):
	-- она раскрашивает @lsp.type.* в цвета активной темы, чтобы clangd
	-- semantic tokens выглядели согласованно.
	integrations = { "semantic_tokens" },

	-- Строка выбора в vim.ui.select (cmake-tools :CMakeSelect*, dressing -> telescope).
	-- В светлых темах base46 красит TelescopeSelection в black2, что почти сливается
	-- с фоном панели. Делаем выбор явно видимым; имена цветов берутся из темы.
	hl_override = {
		TelescopeSelection = { bg = "one_bg3", fg = "white", bold = true },

		-- Диагностики clangd: задаём явно и одинаково для всех тем, чтобы
		-- error/warning различались по цвету (в монохроме они были серыми,
		-- а прежние #c0392b/#b26a00 — оба тёмные и почти неотличимы).
		DiagnosticError = { fg = "#d13438" }, -- красный
		DiagnosticWarn = { fg = "#d19a00" }, -- золотой/янтарный
	},

	hl_add = {
		TelescopeSelectionCaret = { bg = "one_bg3", fg = "white", bold = true },
		TelescopeMultiSelection = { bg = "one_bg2", fg = "white" },

		DiagnosticVirtualTextError = { fg = "#d13438" },
		DiagnosticVirtualTextWarn = { fg = "#d19a00" },
		DiagnosticSignError = { fg = "#d13438" },
		DiagnosticSignWarn = { fg = "#d19a00" },
		DiagnosticFloatingError = { fg = "#d13438" },
		DiagnosticFloatingWarn = { fg = "#d19a00" },
		DiagnosticUnderlineError = { sp = "#d13438", undercurl = true },
		DiagnosticUnderlineWarn = { sp = "#d19a00", undercurl = true },
	},
}
vim.cmd("source /home/*/.config/nvim/lua/plugins/DoxygenToolkit.vim")

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
