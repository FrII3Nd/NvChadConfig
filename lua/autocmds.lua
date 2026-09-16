require "nvchad.autocmds"

local function close_overseer()
  local ok, overseer = pcall(require, "overseer")
  if ok then
    overseer.close()
  end
  -- Закрыть оставшиеся окна вывода Overseer (TaskView/терминал)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.bo[bufnr].filetype == "OverseerOutput" or vim.b[bufnr].overseer_task then
      pcall(vim.api.nvim_win_close, winid, false)
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "trouble",
  callback = function()
    vim.schedule(close_overseer)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "OverseerList",
  callback = function()
    local ok, trouble = pcall(require, "trouble")
    if ok then
      trouble.close()
    end
  end,
})
