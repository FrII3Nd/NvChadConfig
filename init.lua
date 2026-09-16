vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
-- bset clipboard+=unnamedplusootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

vim.g.maplocalleader = ","

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
  extension = {
    inl = "cpp",
    ipp = "cpp",
    tpp = "cpp",
    tcc = "cpp",
    txx = "cpp",
  },
})

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  rocks = {
    enabled = false,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Удаление не копирует текст (d, dd, D)
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("n", "D", '"_D')

-- Изменение текста не копирует старый текст (c, cc, C)
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set("n", "cc", '"_cc')
vim.keymap.set("n", "C", '"_C')

-- Удаление символа (x) тоже в никуда
vim.keymap.set({ "n", "v" }, "x", '"_x')

