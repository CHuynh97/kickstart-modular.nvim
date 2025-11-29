return {
  "goolord/alpha-nvim",
  requires = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
      return
    end


    if vim.fn.has("win32") == 1 then
      plugins_count = vim.fn.len(vim.fn.globpath("~/AppData/Local/nvim-data/site/pack/packer/start", "*", 0, 1))
    else
      plugins_count = vim.fn.len(vim.fn.globpath("~/.local/share/nvim/lazy", "*", 0, 1))
    end

    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
      "",
      "                                       ",
      "                                       ",
      "██  ██ ██████ ██     ██     ▄████▄     ",
      "██████ ██▄▄   ██     ██     ██  ██     ",
      "██  ██ ██▄▄▄▄ ██████ ██████ ▀████▀     ",
      "                                       ",
      "                                       ",
      "                                       ",
      "          ██     ██ ▄████▄ █████▄  ██     ████▄  ",
      "          ██ ▄█▄ ██ ██  ██ ██▄▄██▄ ██     ██  ██ ",
      "           ▀██▀██▀  ▀████▀ ██   ██ ██████ ████▀  ",
      "                                                 ",
      -- "                                                                    ▄ ▄   ",
      -- "▄█████ ▄████▄ ████▄  ██████    ▄   ██▄  ▄██ ▄████▄ █████▄  ██████ ▄█▀ ▀█▄ ",
      -- "██     ██  ██ ██  ██ ██▄▄   ▄▄▄ ▀▄ ██ ▀▀ ██ ██  ██ ██▄▄██▄ ██▄▄   ██   ██ ",
      -- "▀█████ ▀████▀ ████▀  ██▄▄▄▄    ▄▀  ██    ██ ▀████▀ ██   ██ ██▄▄▄▄ ▀█▄ ▄█▀ ",
      -- "                                                                    ▀ ▀   ",
      "",
    }
    dashboard.section.buttons.val = {
      dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
      dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("m", "  BookMarks", ":Telescope marks <CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("c", "  Configuration", ":e ~/.config/nvim<CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }


    dashboard.section.footer.val = {
      "",
      "--   " .. plugins_count .. " plugins installed    --",
      "",
    }

    dashboard.section.footer.opts.hl = "Type"
    -- dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.opts.opts.noautocmd = true
    -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function(event)
        local buf = event.buf
        -- -- make buffer unmodifiable and unscrollable
        -- vim.bo[buf].modifiable = false
        -- vim.bo[buf].buftype = "nofile"
        -- vim.bo[buf].bufhidden = "wipe"
        -- vim.bo[buf].swapfile = false
        -- vim.wo[buf].wrap = false
        -- vim.wo[buf].cursorline = false
        -- vim.wo[buf].number = false
        -- vim.wo[buf].relativenumber = false
        -- vim.wo[buf].signcolumn = "no"

        -- lock view so you can’t scroll
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("normal! gg") -- jump to top
          vim.cmd("setlocal scrolloff=0")
          vim.cmd("setlocal sidescrolloff=0")
          vim.cmd("setlocal norelativenumber nonumber nocursorline")
        end)

        -- disable scroll keymaps entirely
        local keys = { 'j', 'k', '<C-d>', '<C-u>', '<C-f>', '<C-b>' }
        for _, key in ipairs(keys) do
          vim.keymap.set('n', key, '<Nop>', { buffer = buf, silent = true })
        end

        vim.keymap.set('', '<ScrollWheelUp>', '<Nop>', { buffer = buf, silent = true })
        vim.keymap.set('', '<ScrollWheelDown>', '<Nop>', { buffer = buf, silent = true })
        vim.keymap.set('', '<2-ScrollWheelUp>', '<Nop>', { buffer = buf, silent = true })
        vim.keymap.set('', '<2-ScrollWheelDown>', '<Nop>', { buffer = buf, silent = true })
        vim.keymap.set('', '<3-ScrollWheelUp>', '<Nop>', { buffer = buf, silent = true })
        vim.keymap.set('', '<3-ScrollWheelDown>', '<Nop>', { buffer = buf, silent = true })

        -- Hide the cursor
        vim.opt.guicursor:append("a:Cursor/lCursor") -- ensure defined
        vim.cmd("hi! Cursor blend=100")
        vim.cmd("hi! iCursor blend=100")
      end,
    })

    -- When leaving Alpha, restore the cursor visibility and normal behavior
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaClosed",
      callback = function()
        vim.cmd("hi! Cursor blend=0")
        vim.cmd("hi! iCursor blend=0")
      end,
    })


    alpha.setup(dashboard.opts)
  end
}
-- vim: ts=2 sts=2 sw=2 et