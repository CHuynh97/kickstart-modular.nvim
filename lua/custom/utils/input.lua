local M = {}

M.input = function(opts, on_confirm)
  vim.ui.input(opts, function(value)
    -- once the popup is closed, just forward the result
    if on_confirm then
      on_confirm(value)
    end
    -- important: don't leave insert mode hanging!
    vim.schedule(function()
      vim.cmd.stopinsert()
    end)
  end)

  -- force insert mode immediately, but only for the input buffer
  vim.schedule(function()
    if vim.api.nvim_get_mode().mode ~= "i" then
      vim.api.nvim_feedkeys("i", "n", false)
    end
  end)
end

return M
