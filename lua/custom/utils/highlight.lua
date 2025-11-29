local M = {}

M.link_highlight_group = function(target, source)
  vim.api.nvim_set_hl(0, target, { link = source, default = false })
end

return M