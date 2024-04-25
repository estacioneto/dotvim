return {
  dap = {
    {
      '<leader>db',
      mode = 'n',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = '[Dap] Toggle breakpoint',
    },
    {
      '<leader>do',
      mode = 'n',
      function()
        require('dap').step_out()
      end,
      desc = '[Dap] Step out',
    },
    {
      '<leader>di',
      mode = 'n',
      function()
        require('dap').step_into()
      end,
      desc = '[Dap] Step into',
    },
    {
      '<leader>dn',
      mode = 'n',
      function()
        require('dap').step_over()
      end,
      desc = '[Dap] Step over',
    },
    {
      '<leader>ds',
      mode = 'n',
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = '[Dap] Stop',
    },
    {
      '<leader>dc',
      mode = 'n',
      function()
        require('dap').continue()
      end,
      desc = '[Dap] Continue',
    },
    {
      '<leader>dup',
      mode = 'n',
      function()
        require('dap').up()
      end,
      desc = '[Dap] Up',
    },
    {
      '<leader>dj',
      mode = 'n',
      function()
        require('dap').down()
      end,
      desc = '[Dap] Down',
    },
    {
      '<leader>d_',
      mode = 'n',
      function()
        local dap = require 'dap'
        dap.disconnect()
        dap.close()
        dap.run_last()
      end,
      desc = '[Dap] Disconnect',
    },
    {
      '<leader>dr',
      mode = 'n',
      function()
        require('dap').clear_breakpoints()
      end,
      desc = '[Dap] Clear breakpoints',
    },
    {
      '<leader>de',
      mode = 'n',
      function()
        require('dap').set_exception_breakpoints { 'all' }
      end,
      desc = '[Dap] Exception breakpoints',
    },
    {
      '<leader>dk',
      mode = 'n',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = '[Dap] Hover',
    },
    {
      '<leader>d?',
      mode = 'n',
      function()
        local widgets = require 'dap.ui.widgets'
        widgets.centered_float(widgets.scopes)
      end,
      desc = '[Dap] Scopes',
    },
  },
  dapui = {
    {
      '<leader>dui',
      mode = 'n',
      function()
        require('dapui').toggle { reset = true }
      end,
      desc = '[Dap UI] Toggle UI',
    },
    {
      '<leader>duio',
      mode = 'n',
      function()
        require('dapui').open { reset = true }
      end,
      desc = '[Dap UI] Open',
    },
    {
      '<leader>duic',
      mode = 'n',
      function()
        require('dapui').close()
      end,
      desc = '[Dap UI] Close',
    },
    {
      '<leader>duir',
      mode = 'n',
      function()
        local dapui = require 'dapui'

        dapui.close()
        dapui.open { reset = true }
      end,
      desc = '[Dap UI] Reset',
    },
  },
}
