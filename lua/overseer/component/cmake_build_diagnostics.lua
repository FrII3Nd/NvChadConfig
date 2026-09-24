local util = require("overseer.util")

local type_to_severity = {
  e = vim.diagnostic.severity.ERROR,
  E = vim.diagnostic.severity.ERROR,
  w = vim.diagnostic.severity.WARN,
  W = vim.diagnostic.severity.WARN,
  n = vim.diagnostic.severity.INFO,
  N = vim.diagnostic.severity.INFO,
  i = vim.diagnostic.severity.INFO,
  I = vim.diagnostic.severity.INFO,
}

-- Фиксированный namespace + общий список буферов, чтобы очищать
-- старые ошибки даже при новом запуске сборки (новая таска).
local NS = vim.api.nvim_create_namespace("cmake-build-diagnostics")
local tracked = {}

local function clear_all()
  for bufnr in pairs(tracked) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.diagnostic.reset(NS, bufnr)
    end
  end
  tracked = {}
end

return {
  desc = "Show cmake build errors as editor diagnostics, clearing old ones on every result",
  constructor = function()
    return {
      on_result = function(self, task, result)
        clear_all()
        if not result.diagnostics or vim.tbl_isempty(result.diagnostics) then
          return
        end
        for _, diag in ipairs(result.diagnostics) do
          if not diag.filename and diag.bufnr and diag.bufnr ~= 0 then
            diag.filename = vim.api.nvim_buf_get_name(diag.bufnr)
          end
        end
        local grouped = util.tbl_group_by(result.diagnostics, "filename")
        for filename, items in pairs(grouped) do
          local diagnostics = {}
          for _, item in ipairs(items) do
            local lnum_idx = (item.lnum or 1) - 1
            local end_lnum_idx = (item.end_lnum and item.end_lnum > 0) and (item.end_lnum - 1)
              or (lnum_idx + 1)
            table.insert(diagnostics, {
              message = item.text,
              severity = type_to_severity[item.type] or vim.diagnostic.severity.ERROR,
              lnum = lnum_idx,
              end_lnum = end_lnum_idx,
              col = item.col or 0,
              end_col = item.end_col,
              source = task.name,
              code = item.code,
            })
          end
          local bufnr = vim.fn.bufadd(filename)
          vim.diagnostic.set(NS, bufnr, diagnostics)
          tracked[bufnr] = true
        end
      end,
    }
  end,
}
