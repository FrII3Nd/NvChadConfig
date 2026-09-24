require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Telescope Find commands" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit (GUI)" })

map("n", "<leader>oo", "<cmd>OverseerToggle!<cr>", { desc = "Overseer Toggle" })

map("n", "<leader>fm", "<cmd>Format<cr>", { desc = "Format file with conform" })

map("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
map("n", "<leader>cc", "<cmd>CMakeClean<cr>", { desc = "CMake Clean" })
map("n", "<leader>ct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "CMake Select Target" })
map("n", "<leader>cp", "<cmd>CMakeSelectBuildPreset<cr>", { desc = "CMake Select Build Preset" })
map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake Run" })
map("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake Debug" })


map("n", "<leader>ba", ":%bd<CR>", { desc = "Close all buffers" })

map("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close all buffers except current" })

-- Normal and Visual mode mappings
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle AI Chat" })
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions Menu" })
vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "Inline AI Prompt" })

-- Visual mode specific: Add selected code to the chat
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to AI Chat" })

vim.keymap.set({ "n", "v" }, "<leader>fr", "<cmd>GrugFarWithin<cr>", { desc = "Find & Replace" })
map("n", "<leader>dx", "<cmd> Dox <cr>", { desc = "Doxygen: Generate  func doc" })
map("n", "<leader>da", "<cmd> DoxAuthor <cr>", { desc = "Doxygen: Generate file doc" })
map("n", "<leader>dl", "<cmd> DoxLic <cr>", { desc = "Doxygen: license doc" })

local ls = require("luasnip")
-- vim.keymap.set({"i", "s"}, "<Tab>", function() ls.jump(1) end, {silent = true})
-- vim.keymap.set({"i", "s"}, "<S-Tab>", function() ls.jump(-1) end, {silent = true})

map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header"})
map("n", "<leader>co", "<cmd>ClangdTypeHierarchy<cr>", { desc ="Type Hierarchy"})
map("n", "<leader>ci", "<cmd>ClangdSymbolInfo<cr>", { desc ="Symbol Info"})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Actions" })
map("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "LSP Signature Help" })

-- Плавающее окно для осмотра переменной под курсором (аналог наведения мышки).
-- Не забирает фокус и закрывается само при движении курсора / повторном K.
local hover_group = vim.api.nvim_create_augroup("UserDapHoverAutoclose", { clear = true })

local function close_hover()
  vim.api.nvim_clear_autocmds({ group = hover_group })
  local state = require("dap-view.state")
  local winnr = state.hover_winnr
  local bufnr = state.hover_bufnr
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    pcall(vim.api.nvim_win_close, winnr, true)
  end
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
  state.hover_winnr = nil
  state.hover_bufnr = nil
end

vim.keymap.set("n", "K", function()
  if not require("dap").session() then
    vim.lsp.buf.hover()
    return
  end

  local state = require("dap-view.state")
  local winnr = state.hover_winnr

  if winnr and vim.api.nvim_win_is_valid(winnr) then
    if vim.api.nvim_get_current_win() == winnr then
      -- K внутри окна: закрыть
      close_hover()
    else
      -- второе K: войти в окно (фокус) и отключить авто-закрытие
      vim.api.nvim_clear_autocmds({ group = hover_group })
      vim.api.nvim_set_current_win(winnr)
    end
    return
  end

  require("dap-view").hover(nil, false) -- первое K: открыть БЕЗ фокуса

  -- авто-закрытие при движении курсора (пока не вошли в окно вторым K)
  vim.api.nvim_clear_autocmds({ group = hover_group })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
    group = hover_group,
    callback = function()
      local st = require("dap-view.state")
      if st.hover_winnr and vim.api.nvim_win_is_valid(st.hover_winnr) then
        close_hover()
      end
    end,
  })
end, { desc = "DAP/LSP: Hover" })

-- DAP (Debugger) Mappings
map("n", "<F5>", "<cmd>DapContinue<cr>", { desc = "DAP Continue / Start" })
map("n", "<F10>", "<cmd>DapStepOver<cr>", { desc = "DAP Step Over" })
map("n", "<F11>", "<cmd>DapStepInto<cr>", { desc = "DAP Step Into" })
map("n", "<F12>", "<cmd>DapStepOut<cr>", { desc = "DAP Step Out" })
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "DAP Toggle Breakpoint" })
map("n", "<leader>dc", "<cmd>DapTerminate<cr>", { desc = "DAP Terminate" })
map("n", "<leader>dq", function()
  require("dap-view").close()
  require("dap").terminate()
end, { desc = "DAP Close UI & Terminate" })
map("n", "<leader>dr", "<cmd>DapRestart<cr>", { desc = "DAP Restart" })
map("n", "<leader>dv", function()
  require("dap-view").virtual_text_toggle()
end, { desc = "DAP Virtual Text Toggle" })
map("n", "<leader>dp", "<cmd>DapPause<cr>", { desc = "DAP Pause" })
map("n", "<leader>do", function()
  require("dap-view").toggle()
end, { desc = "DAP View Toggle" })
map("n", "<leader>dw", "<cmd>DapViewWatch<cr>", { desc = "DAP Watch expression" })
