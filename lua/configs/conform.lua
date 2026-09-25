-- Настройка форматирования через conform.nvim
-- Lua  — stylua (Mason, ставится через :MasonInstall stylua)
-- C/C++ — через clangd (LSP): у clangd встроен clang-format, он читает .clang-format
--         в корне проекта. Отдельный бинарник clang-format не нужен.
return {
  formatters_by_ft = {
    lua = { "stylua" },
    -- Если позже поставишь отдельный clang-format (apt/Mason), верни так:
    -- c = { "clang_format" },
    -- cpp = { "clang_format" },
  },

  -- если для файлтипа нет conform-форматтера (c/cpp) — падаем на LSP (clangd)
  default_format_opts = {
    lsp_format = "fallback",
  },

  -- formatters = {
  --   clang_format = { command = vim.fn.stdpath("data") .. "/mason/bin/clang-format" },
  -- },

  -- форматирование при сохранении (раскомментируй, если нужно)
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}
