return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = { char = "│" },
      scope = {
        enabled = true, -- keeps the current scope highlighted
        show_start = true,
        show_end = true,
      },
    },
  },
}
