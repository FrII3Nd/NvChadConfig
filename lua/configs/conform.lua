-- Настройка форматирования через conform.nvim
-- Форматтером для C/C++ является clang-format из Mason (устанавливается через :MasonInstall clang-format)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

return {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
  formatters = {
    -- используем clang-format, установленный через Mason (версия 23)
    clang_format = {
      command = mason_bin .. "/clang-format",
      -- clang-format сам ищет .clang-format в корне проекта (по умолчанию),
      -- поэтому отдельный prepend_args не нужен; если файла нет — используется LLVM style
    },
  },

  -- форматирование при сохранении (раскомментируй, если нужно)
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}