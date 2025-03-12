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
      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = {
          vim.fn.stdpath 'data'
            .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js',
        },
      }

      dap.adapters.chrome = {
        type = 'executable',
        command = 'node',
        args = {
          vim.fn.stdpath 'data'
            .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js',
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
    'jay-babu/mason-nvim-dap.nvim',
    config = function()
      local ensure_installed = { 'node2', 'python' }

      if vim.fn.executable 'go' == 1 then
        table.insert(ensure_installed, 'delve')
      end

      require('mason-nvim-dap').setup {
        ensure_installed = ensure_installed,
      }
    end,
  },
}
