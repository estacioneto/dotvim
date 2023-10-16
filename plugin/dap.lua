-- nvim-dap
local dap = require('dap')

-- Options
-- theHamsta/nvim-dap-virtual-text and mfussenegger/nvim-dap
vim.g.dap_virtual_text = true

-- Config
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.nvim/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
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

vim.fn.sign_define('DapBreakpoint', {text='✋', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='👉', texthl='', linehl='', numhl=''})

-- Mappings
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>do', dap.step_out)
vim.keymap.set('n', '<leader>di', dap.step_into)
vim.keymap.set('n', '<leader>dn', dap.step_over)
vim.keymap.set('n', '<leader>ds', dap.stop)
vim.keymap.set('n', '<leader>dc', dap.continue)
vim.keymap.set('n', '<leader>du', dap.up)
vim.keymap.set('n', '<leader>dj', dap.down)
vim.keymap.set('n', '<leader>d_', function()
  dap.disconnect()
  dap.close()
  dap.run_last()
end)
vim.keymap.set('n', '<leader>dr', function ()
  dap.repl.open({}, 'vsplit')
  vim.cmd.wincmd('l')
end)
vim.keymap.set('n', '<leader>de', function() dap.set_exception_breakpoints({'all'}) end)

-- FIXME: dap.ui.variables not found
-- local dap_ui_variables = require('dap.ui.variables')
-- vim.keymap.set('n', '<leader>di', dap_ui_variables.hover)
-- vim.keymap.set('v', '<leader>dvi', dap_ui_variables.visual_hover)
-- vim.keymap.set('n', '<leader>d?', dap_ui_variables.scopes)

local debug_helper = require('estacio.debug_helper')
vim.keymap.set('n', '<leader>da', debug_helper.attach)
vim.keymap.set('n', '<leader>dA', debug_helper.attachToRemote)

local dap_ui_widgets = require('dap.ui.widgets')
vim.keymap.set('n', '<leader>dk', dap_ui_widgets.hover)
vim.keymap.set('n', '<leader>d? local', function () dap_ui_widgets.centered_float(dap_ui_widgets.scopes) end)

-- Dap telescope
require('telescope').load_extension('dap')

-- Dap telescope mappings
vim.keymap.set('n', '<leader>dtf', ':Telescope dap frames<CR>')
vim.keymap.set('n', '<leader>dtc', ':Telescope dap commands<CR>')
vim.keymap.set('n', '<leader>dtlb', ':Telescope dap list_breakpoints<CR>')
