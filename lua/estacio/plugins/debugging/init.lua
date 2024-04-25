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
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    keys = require('estacio.plugins.debugging.keymaps').dapui,
    config = function()
      local dap, dapui = require 'dap', require 'dapui'

      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
    end,
  },
  {

    'theHamsta/nvim-dap-virtual-text',
    config = function()
      vim.g.dap_virtual_text = true
      require('nvim-dap-virtual-text').setup()
    end,
  },
}
