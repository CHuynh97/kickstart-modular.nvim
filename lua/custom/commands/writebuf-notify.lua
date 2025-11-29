-- Suppress vanilla "written" messages
vim.opt.shortmess:append("W")

-- Track unmodified saves so we can skip notifying
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_get_option(buf, "modified") then
      vim.b[buf].skip_notify = true
    end
  end,
})

-- Send save notifications to fidget (via vim.notify)
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local buf = args.buf

    -- Skip if flagged from BufWritePre
    if vim.b[buf].skip_notify then
      vim.b[buf].skip_notify = nil
      return
    end

    -- Skip if buffer is still marked modified (write failed)
    if vim.api.nvim_buf_get_option(buf, "modified") then
      return
    end

    local fname = vim.fn.fnamemodify(args.file, ":~:.")
    local line_count = vim.api.nvim_buf_line_count(buf)
    vim.notify(
      string.format("Saved %s (%d lines)", fname, line_count),
      vim.log.levels.INFO,
      { title = "Buffer Written" }
    )
  end,
})
