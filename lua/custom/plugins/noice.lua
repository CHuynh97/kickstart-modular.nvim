return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("noice").setup({
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
        {
          filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
          view = 'popup',
          opts = {
            level = 'info',
            skip = false,
            replace = false,
          },
        }
      },
      presets = {
        lsp_doc_border = true,
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          -- override the default lsp markdown formatter with Noice
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          -- override the lsp markdown formatter with Noice
          ["vim.lsp.util.stylize_markdown"] = true,
          -- override cmp documentation with Noice (needs the other options to work)
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = false },     -- <-- HERE!
        signature = { enabled = false }, -- <-- HERE!
        progress = { enabled = false },
      },
    })
  end
}
-- vim: ts=2 sts=2 sw=2 et