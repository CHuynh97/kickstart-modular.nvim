-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = '[L]SP go to [D]efinitions' })
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = '[L]SP go to [R]efinitions' })
      vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, { desc = '[L]SP go to [I]mplementations' })
      vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = '[L]SP [C]ode Actions' })

      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
      -- vim.keymap.set('n', '<leader>gb', builtin.git_blame, { desc = '[G]it [B]lame' })


      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      -- local builtin = require("telescope.builtin")

      -- Wrapper to launch current_buffer_fuzzy_find with <C-r>
      local function buffer_search_and_replace()
        builtin.current_buffer_fuzzy_find({
          attach_mappings = function(_, map)
            map("i", "<C-r>", function(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)
              local selections = picker:get_multi_selection()

              -- If nothing selected, fallback to just the highlighted entry
              if vim.tbl_isempty(selections) then
                table.insert(selections, action_state.get_selected_entry())
              end

              actions.close(prompt_bufnr)

              if #selections > 0 then
                local custom_input = require("custom.utils.input")
                custom_input.input({ prompt = "Replace with: " }, function(replace)
                  if not replace then return end
                  if replace == "" then
                    vim.notify("No replace value provided", vim.log.levels.WARN)
                    return
                  end

                  local prompt = action_state.get_current_line() or ""
                  if prompt == "" then
                    vim.notify("No search pattern provided", vim.log.levels.WARN)
                    return
                  end
                  local search = vim.fn.escape(prompt, "/\\")
                  local replace_esc = vim.fn.escape(replace, "/\\")
                  for _, entry in ipairs(selections) do
                    local lnum = entry.lnum or entry.lnum_start or entry[1] -- depends on picker
                    if lnum then
                      local cmd = string.format("%d s/%s/%s/g", lnum, search, vim.fn.escape(replace_esc, "/\\"))
                      vim.cmd(cmd)
                    end
                  end
                  vim.cmd("nohlsearch")
                end)
              end
            end)
            return true
          end,
        })
      end


      -- local function escape_lua_pattern(s)
      --   -- escape Lua pattern magic characters so we can use string.gsub safely
      --   return s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
      -- end

      local function project_search_and_replace()
        builtin.live_grep({
          attach_mappings = function(_, map)
            map("i", "<C-r>", function(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)

              -- capture the prompt BEFORE closing the picker
              local prompt = (picker and picker._get_prompt and picker:_get_prompt()) or ""

              local selections = picker:get_multi_selection()
              if vim.tbl_isempty(selections) then
                table.insert(selections, action_state.get_selected_entry())
              end

              actions.close(prompt_bufnr)

              if #selections == 0 then
                vim.notify("No selections found", vim.log.levels.WARN)
                return
              end

              if prompt == "" then
                vim.notify("Search pattern empty", vim.log.levels.WARN)
                return
              end

              local custom_input = require('custom.utils.input')
              custom_input.input({ prompt = "Replace with: " }, function(replace)
                if not replace or replace == "" then
                  vim.notify("No replace value provided", vim.log.levels.WARN)
                  return
                end

                -- convert the user prompt (which may contain rg-style escapes like \.)
                -- into a literal substring we expect to find in the file
                -- simplest: remove backslashes that were used to escape characters for rg
                -- (caveat: if user intentionally wanted backslashes, this removes them)
                local literal = prompt:gsub("\\", "")

                -- escape for Lua pattern
                local lua_pat = literal:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")

                -- group selections by file
                local by_file = {}
                for _, entry in ipairs(selections) do
                  if entry.filename and entry.lnum then
                    by_file[entry.filename] = by_file[entry.filename] or {}
                    table.insert(by_file[entry.filename], entry)
                  end
                end

                local total_replacements = 0
                local files_touched = 0

                -- process files
                for file, entries in pairs(by_file) do
                  vim.cmd("edit " .. vim.fn.fnameescape(file))
                  files_touched = files_touched + 1

                  -- sort descending so edits don't shift later line numbers
                  table.sort(entries, function(a, b) return a.lnum > b.lnum end)

                  for _, entry in ipairs(entries) do
                    local lnum = entry.lnum - 1
                    local ok, lines = pcall(vim.api.nvim_buf_get_lines, 0, lnum, lnum + 1, false)
                    if not ok or not lines or not lines[1] then goto continue_line end
                    local line = lines[1]

                    -- do a literal/global replacement using Lua patterns (we escaped it)
                    -- escape Lua pattern magic characters so we can use string.gsub safely
                    local new_line, n = line:gsub(lua_pat, replace)
                    if n > 0 and new_line ~= line then
                      vim.api.nvim_buf_set_lines(0, lnum, lnum + 1, false, { new_line })
                      total_replacements = total_replacements + n
                    end

                    ::continue_line::
                  end

                  -- save file if modified
                  if vim.bo.modified then
                    vim.cmd("update")
                  end
                end

                vim.cmd("nohlsearch")
                vim.notify(string.format("Replaced %d occurrences in %d files", total_replacements, files_touched),
                  vim.log.levels.INFO)
              end)
            end)
            return true
          end,
        })
      end


      -- Keymaps
      vim.keymap.set("n", "<leader>/", buffer_search_and_replace, { desc = "Search & Replace in Buffer" })
      vim.keymap.set("n", "<leader>sg", project_search_and_replace, { desc = "Search & Replace in Project" })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
