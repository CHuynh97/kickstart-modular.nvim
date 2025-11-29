return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      -- 'Kaiser-Yang/blink-cmp-avante', -- TODO uncomment when actually integrating avante
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        -- documentation = { auto_show = false, auto_show_delay_ms = 500 },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = "rounded"
          }
        },
        menu = {
          border = "rounded",
          -- winhighlight = 'Pmenu:Pmenu,PmenuBorder:PmenuBorder,PmenuBorder:CmpDocBorder',
        }
       
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' }, -- 'avante' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          -- TODO uncomment below when integrating avante
          -- avante = {
          --   module = 'blink-cmp-avante',
          --   name = 'Avante',
          --   opts = {
          --       -- options for blink-cmp-avante
          --   }
          -- },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true, window = { border = 'rounded' } },
    },
    config = function (_, opts)
      local blink = require("blink.cmp")
      blink.setup(opts)

      -- Sync highlight groups with Telescope’s
      local highlight = require("custom.utils.highlight")


      highlight.link_highlight_group("BlinkCmpMenu", "TelescopeNormal")
      highlight.link_highlight_group("BlinkCmpMenuBorder", "TelescopeBorder")
      highlight.link_highlight_group("BlinkCmpDoc", "TelescopeNormal")
      highlight.link_highlight_group("BlinkCmpDocBorder", "TelescopeBorder")
      highlight.link_highlight_group("BlinkCmpDocSeparator", "TelescopeBorder")
      highlight.link_highlight_group("BlinkCmpSignatureHelp", "TelescopeNormal")
      highlight.link_highlight_group("BlinkCmpSignatureHelpBorder", "TelescopeBorder")
    end
  },
}
-- vim: ts=2 sts=2 sw=2 et
