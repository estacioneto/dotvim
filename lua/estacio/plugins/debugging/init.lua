return {
  -- Debugging
  {
    'mfussenegger/nvim-dap',
    keys = require('estacio.plugins.debugging.keymaps').dap,
    config = function()
      local dap = require 'dap'

      -- Options
      dap.defaults.fallback.terminal_win_cmd = '25split new'

      -- Config
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            vim.fn.stdpath 'data'
              .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }

      for _, lang in ipairs {
        'javascript',
        'typescript',
      } do
        dap.configurations[lang] = require 'estacio.plugins.debugging.nodejs'
      end

      vim.fn.sign_define(
        'DapBreakpoint',
        { text = '✋', texthl = '', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '👉', texthl = '', linehl = '', numhl = '' }
      )
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    config = function()
      require('dap-python').setup(
        vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
      )
    end,
  },
  {
    'leoluz/nvim-dap-go',
    config = function()
      require('dap-go').setup()
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    enabled = false,
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = require('estacio.plugins.debugging.keymaps').dapui,
    config = function()
      local dap, dapui = require 'dap', require 'dapui'

      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  {
    'miroshQa/debugmaster.nvim',
    -- osv is needed if you want to debug neovim lua code. Also can be used
    -- as a way to quickly test-drive the plugin without configuring debug adapters
    dependencies = {
      'mfussenegger/nvim-dap',
      'jbyuki/one-small-step-for-vimkind',
    },
    config = function()
      local dm = require 'debugmaster'

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>dm',
        dm.mode.toggle,
        { nowait = true }
      )

      dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    config = function()
      local ensure_installed = { 'js', 'python' }

      if vim.fn.executable 'go' == 1 then
        table.insert(ensure_installed, 'delve')
      end

      require('mason-nvim-dap').setup {
        ensure_installed = ensure_installed,
      }
    end,
  },
}
