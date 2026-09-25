-- LSP настройки: clangd (C/C++) через Mason, + lua_ls, + (опционально) cmake
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

-- clangd из Mason (устанавливается через :MasonInstall clangd); если его нет — системный
local mason_clangd = mason_bin .. "/clangd"
local clangd_cmd = (vim.fn.filereadable(mason_clangd) == 1) and mason_clangd or "clangd"

-- ищет compile_commands.json в дереве сборки (cmake-build-*, build/, build/<target>/)
-- и делает симлинк <проект>/compile_commands.json, чтобы clangd нашёл пути ESP-IDF
local function setup_smart_compile_commands()
  local root = vim.fn.getcwd()
  local find_cmd = string.format(
    "find %s -maxdepth 5 -type f -name compile_commands.json "
      .. "\\( -path '*/build/*' -o -path '*/cmake-build-*/*' \\) "
      .. "! -path '*/.git/*' 2>/dev/null",
    root
  )
  local handle = io.popen(find_cmd)
  if not handle then
    return
  end
  local out = handle:read("*a")
  handle:close()
  if out == "" then
    return
  end

  -- выбираем самую свежую БД (их может быть несколько: build/<chip>/...)
  local newest, newest_mtime
  for p in out:gmatch("%S+") do
    local mt = vim.fn.getftime(p)
    if newest_mtime == nil or mt > newest_mtime then
      newest, newest_mtime = p, mt
    end
  end
  if not newest or newest == root .. "/compile_commands.json" then
    return
  end

  os.execute(string.format("ln -sfn %q %q", newest, root .. "/compile_commands.json"))
  print("LSP: compile_commands.json -> " .. newest)
end

setup_smart_compile_commands()

-- NvChad по умолчанию ГАСИТ semantic tokens: их on_init выставляет
-- client.server_capabilities.semanticTokensProvider = nil. Нам семантические
-- токены clangd нужны, поэтому подменяем on_init пустой функцией.
local on_init = function() end

-- Красивый hover для LSP (clangd и др.): скруглённая рамка + ограничение размера.
-- Фокус не забирает и закрывается при движении курсора — это Neovim делает сам.
-- (без vim.lsp.with, т.к. он deprecated в nvim 0.12)
local hover_orig = vim.lsp.handlers.hover
local hover_opts = { border = "rounded", max_width = 80, max_height = 20 }
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  local bufnr, winnr = hover_orig(err, result, ctx, vim.tbl_deep_extend("force", config or {}, hover_opts))
  -- NvChad отключает легаси-синтаксис markdown, поэтому запускаем treesitter на hover-буфере,
  -- иначе markdown (```блоки```, **жирное**) показывается как сырой текст.
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    local fbuf = vim.api.nvim_win_get_buf(winnr)
    if vim.bo[fbuf].filetype == "markdown" then
      pcall(vim.treesitter.start, fbuf, "markdown")
    end
  end
end

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.lsp.config("clangd", {
  cmd = {
    clangd_cmd,
    "--offset-encoding=utf-16",
    "--query-driver=/opt/esp/tools/xtensa-esp-elf/**/bin/*-gcc,/opt/esp/tools/riscv32-esp-elf/**/bin/*-gcc,/opt/esp/tools/esp32ulp-elf/**/bin/*-gcc,/opt/esp/tools/**/bin/*-gcc,/opt/Xilinx/Vitis/2024.2/gnu/aarch64/**/**/**/*g++,/opt/Xilinx/Vitis/2024.2/gnu/aarch32/**/*g++,/opt/Xilinx/Vitis/2024.2/gnu/riscv/**/**/**/*g++",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  on_attach = function(client, bufnr)
    -- Семантические токены clangd: точная подсветка сущностей по данным
    -- компилятора (функции, параметры, типы, пространства имён). В nvim 0.12
    -- они включены глобально по умолчанию — включаем явно и per-buffer,
    -- чтобы не зависеть от дефолтов и было видно в конфиге.
    if client:supports_method "textDocument/semanticTokens/full" then
      vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
    end

    -- подсветка inlay hints (типы у аргументов, вывод шаблонов и т.д.)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
  on_init = on_init,
  capabilities = (function()
    local caps = vim.lsp.protocol.make_client_capabilities()
    caps.textDocument.foldingRange = {
      dynamicRegistration = true,
      lineFoldingOnly = true,
    }
    caps.textDocument.hover.contentFormat = { "markdown", "plaintext" }
    return caps
  end)(),
})

vim.lsp.enable "clangd"
vim.lsp.enable "lua_ls"

-- clangd помечает литералы true/false как semantic token типа "keyword",
-- поэтому они красились как ключевые слова (в светлых темах — фиолетовым).
-- Перекрашиваем такие токены в @boolean (цвет чисел/констант темы).
vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(ev)
    local token = ev.data.token
    if token.type ~= "keyword" then
      return
    end
    local line = vim.api.nvim_buf_get_lines(ev.buf, token.line, token.line + 1, false)[1]
    local text = line and line:sub(token.start_col + 1, token.end_col)
    if text == "true" or text == "false" then
      vim.lsp.semantic_tokens.highlight_token(token, ev.buf, ev.data.client_id, "@boolean")
    end
  end,
})

-- cmake-language-server ставится через :MasonInstall cmake-language-server
-- включаем только если он реально установлен (иначе ошибки спавна)
if vim.fn.executable "cmake-language-server" == 1 then
  vim.lsp.enable "cmake"
end

vim.api.nvim_create_user_command("Format", function(args)
  require("conform").format { args = args.fargs, async = args.bang }
end, { nargs = "*", bang = true, desc = "Format buffer using conform" })