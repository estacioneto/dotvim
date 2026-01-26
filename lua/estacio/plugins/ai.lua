-- See https://github.com/yetone/avante.nvim
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = false,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = '<TAB>',
            accept_word = false,
            accept_line = false,
            next = '<C-c><C-n>',
            prev = '<C-c><C-p>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          typescript = true,
          typescriptreact = true,
          javascript = true,
          css = true,
          python = true,

          lua = true,
          markdown = true,

          erlang = true,
          go = true,
          java = true,
          sh = function()
            return not string.match(
              vim.fs.basename(vim.api.nvim_buf_get_name(0)),
              '^%.env.*'
            )
          end,
          ['.'] = false,
          ['*'] = false,
        },

        copilot_node_command = vim.fn.system { 'which', 'node' },
        copilot_model = 'gpt-4o-copilot',
      }
    end,
  },
  {
    'NickvanDyke/opencode.nvim',
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      {
        'folke/snacks.nvim',
        opts = { input = {}, picker = {}, terminal = {} },
      },
    },
    config = function()
      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<C-t>', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, '<leader>gor', function()
        return require('opencode').operator '@this '
      end, { desc = 'Add range to opencode', expr = true })
      vim.keymap.set('n', '<leader>gol', function()
        return require('opencode').operator '@this ' .. '_'
      end, { desc = 'Add line to opencode', expr = true })

      vim.keymap.set('n', '<S-C-u>', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<S-C-d>', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
      vim.keymap.set(
        'n',
        '+',
        '<C-a>',
        { desc = 'Increment under cursor', noremap = true }
      )
      vim.keymap.set(
        'n',
        '-',
        '<C-x>',
        { desc = 'Decrement under cursor', noremap = true }
      )

      vim.g.opencode_opts = {
        provider = {
          enabled = 'terminal',
        },
      }
    end,
  },
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
    },
    -- Remove lazy loading to ensure MCPHub is available when avante.nvim loads
    -- cmd = "MCPHub",
    build = 'npm install -g mcp-hub@latest', -- Installs required mcp-hub npm module
    config = function()
      local root_mcphub_path = vim.fn.expand '~/.vim/lua/estacio/plugins/mcphub'

      require('mcphub').setup {
        config = vim.fn.expand(root_mcphub_path .. '/servers.json'),
        auto_approve = true,
        extensions = {
          avante = {
            make_slash_commands = true, -- make /slash commands from MCP server prompts
          },
        },
        -- Add any additional configuration needed for your Puppeteer server
        -- For example, you might need to specify server settings:
        -- servers = {
        --   puppeteer = {
        --     enabled = true,
        --     -- any specific puppeteer server settings
        --   }
        -- }
      }
    end,
  },
}
