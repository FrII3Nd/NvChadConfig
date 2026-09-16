local configs = require "nvchad.configs.lspconfig"

local function setup_smart_compile_commands()
  local root = vim.fn.getcwd()
  local handle = io.popen("find " .. root .. "/cmake-build-* -name compile_commands.json 2>/dev/null | head -n 1")
  local found_path = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if found_path ~= "" then
    os.execute("ln -sf " .. found_path .. " " .. root .. "/compile_commands.json")
    print("LSP: Linked compile_commands from " .. found_path)
  end
end

setup_smart_compile_commands()
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = true,
  lineFoldingOnly = true,
}

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--query-driver=/opt/Xilinx/Vitis/2024.2/gnu/aarch64/**/**/**/*g++,/opt/Xilinx/Vitis/2024.2/gnu/aarch32/**/*g++,/opt/Xilinx/Vitis/2024.2/gnu/riscv/**/**/**/*g++,/opt/esp/tools/**/bin/*-gcc",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--header-insertion=never"
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    require("clangd_extensions").setup({
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },
            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
        },
    })
  end,
  on_init = on_init,
  capabilities = (function()
    local caps = capabilities
    caps.textDocument.hover.contentFormat = { "markdown", "plaintext" }
    return caps
  end)(),
})

vim.lsp.enable "clangd"
vim.lsp.enable "lua_ls"
vim.lsp.enable "cmake"

require("conform").setup({
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
  formatters = {
    ["clang-format"] = {
      -- Явно указываем путь к вашему clang-format 22
      command = "/usr/bin/clang-format", 
      -- Принудительно заставляем его читать файл .clang-format из корня проекта
      prepend_args = { "-style=file" },
    },
  },
})

vim.api.nvim_create_user_command("Format", function(args)
  require("conform").format { args = args.fargs, async = args.bang }
end, { nargs = "*", bang = true, desc = "Format buffer using conform" })



