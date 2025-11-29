return {
  "ray-x/go.nvim",
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
	  go = "/Users/chrishuynh/go/bin/go",
    disable_defaults = true,
    remap_commands = {
      Ginkgo = false,
      GinkgoFile = false,
    },
    lsp_keymaps = false,
    dap_debug = false,
  },
  config = function(lp, opts)
    require("go").setup(opts)
  end,
  ft = {"go", 'gomod'},
  build = ':lua require("go.install").update_all_sync()',
}
-- vim: ts=2 sts=2 sw=2 et