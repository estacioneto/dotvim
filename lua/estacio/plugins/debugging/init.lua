return {
  -- Debugging
  {
    'mfussenegger/nvim-dap',
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
        dap.configurations[lang] = require('estacio.plugins.debugging.nodejs')
      end
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  },
  'theHamsta/nvim-dap-virtual-text',
}
