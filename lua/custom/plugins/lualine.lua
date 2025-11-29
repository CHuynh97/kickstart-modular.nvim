return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = vim.g.have_nerd_font,
      theme = "auto",
      globalstatus = true,
    }
  },
}
-- vim: ts=2 sts=2 sw=2 et