-- nvim-dap
local dap, dapui = require('dap'), require('dapui')

-- Options
dap.defaults.fallback.terminal_win_cmd = '25split new'

-- Config
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.nvim/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}

local node_config = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to remote',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
    address = "127.0.0.1",
    port = 9229,
    protocol = 'inspector'
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.configurations.javascript = node_config
dap.configurations.typescript = node_config

vim.fn.sign_define('DapBreakpoint', {text='✋', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='', numhl=''})

-- Mappings
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.step_into)
vim.keymap.set('n', '<leader>dn', dap.step_over)
vim.keymap.set('n', '<leader>ds', function()
  dap.terminate()
  dapui.close()
end)
vim.keymap.set('n', '<leader>dc', dap.continue)
vim.keymap.set('n', '<leader>dup', dap.up)
vim.keymap.set('n', '<leader>dj', dap.down)
vim.keymap.set('n', '<leader>d_', function()
  dap.disconnect()
  dap.close()
  dap.run_last()
end)
vim.keymap.set('n', '<leader>dr', dap.clear_breakpoints)
vim.keymap.set('n', '<leader>de', function() dap.set_exception_breakpoints({'all'}) end)

-- Helper mappings
local debug_helper = require('estacio.debug_helper')
vim.keymap.set('n', '<leader>da', debug_helper.attach)
vim.keymap.set('n', '<leader>dA', debug_helper.attachToRemote)
vim.keymap.set('n', '<leader>dJ', debug_helper.debugJest)

local dap_ui_widgets = require('dap.ui.widgets')
vim.keymap.set('n', '<leader>dk', dap_ui_widgets.hover)
vim.keymap.set('n', '<leader>d?', function () dap_ui_widgets.centered_float(dap_ui_widgets.scopes) end)

-- Dap telescope
require('telescope').load_extension('dap')

-- Dap telescope mappings
vim.keymap.set('n', '<leader>dtf', ':Telescope dap frames<CR>')
vim.keymap.set('n', '<leader>dtc', ':Telescope dap commands<CR>')
vim.keymap.set('n', '<leader>dtlb', ':Telescope dap list_breakpoints<CR>')

-- Dap virtual text
-- theHamsta/nvim-dap-virtual-text and mfussenegger/nvim-dap
vim.g.dap_virtual_text = true
require('nvim-dap-virtual-text').setup()

vim.keymap.set('n', '<leader>dui', function() dapui.toggle({ reset = true }) end)
vim.keymap.set('n', '<leader>duio', function() dapui.open({ reset = true }) end)
vim.keymap.set('n', '<leader>duic', dapui.close)
vim.keymap.set('n', '<leader>duir', function()
  dapui.close()
  dapui.open({ reset = true })
end)

-- Dap ui: https://github.com/rcarriga/nvim-dap-ui
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
  -- dapui.close()
  -- end
  -- dap.listeners.before.event_exited["dapui_config"] = function()
    -- dapui.close()
    -- end
