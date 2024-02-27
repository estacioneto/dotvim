-- nvim-dap
local dap, dapui = require 'dap', require 'dapui'

-- Options
dap.defaults.fallback.terminal_win_cmd = '25split new'

-- Config
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath 'data' .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js',
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
    name = 'Attach to remote (localhost)',
    type = 'node2',
    request = 'attach',
    address = '127.0.0.1',
    port = 9229,
    protocol = 'inspector',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
}

-- Not working :/
local react_native_config = {
  {
    name = 'React native',
    type = 'node2',
    request = 'attach',
-- cwd = os.getenv 'KLAPP_NATIVE_PATH',
-- protocol = 'inspector',
-- console = 'integratedTerminal',
    address = 'localhost',
    port = 8081,
  },
  {
    name = 'Chrome',
    type = 'chrome',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    address = '127.0.0.1',
    port = 8081,
  },
}

for _, lang in ipairs {
  'javascript',
  'typescript',
} do
  dap.configurations[lang] = node_config
end

for _, lang in ipairs {
  'javascriptreact',
  'typescriptreact',
} do
  dap.configurations[lang] = react_native_config
end

vim.fn.sign_define(
  'DapBreakpoint',
  { text = '✋', texthl = '', linehl = '', numhl = '' }
)
vim.fn.sign_define(
  'DapStopped',
  { text = '👉', texthl = '', linehl = '', numhl = '' }
)

-- Mappings
vim.keymap.set(
  'n',
  '<leader>db',
  dap.toggle_breakpoint,
  { desc = '[Dap] Toggle breakpoint' }
)
vim.keymap.set('n', '<leader>do', dap.step_out, { desc = '[Dap] Step out' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[Dap] Step into' })
vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = '[Dap] Step over' })
vim.keymap.set('n', '<leader>ds', function()
  dap.terminate()
  dapui.close()
end, { desc = '[Dap] Stop' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[Dap] Continue' })
vim.keymap.set('n', '<leader>dup', dap.up, { desc = '[Dap] Up' })
vim.keymap.set('n', '<leader>dj', dap.down, { desc = '[Dap] Down' })
vim.keymap.set('n', '<leader>d_', function()
  dap.disconnect()
  dap.close()
  dap.run_last()
end, { desc = '[Dap] Disconnect' })
vim.keymap.set(
  'n',
  '<leader>dr',
  dap.clear_breakpoints,
  { desc = '[Dap] Clear breakpoints' }
)
vim.keymap.set('n', '<leader>de', function()
  dap.set_exception_breakpoints { 'all' }
end, { desc = '[Dap] Exception breakpoints' })

local dap_ui_widgets = require 'dap.ui.widgets'
vim.keymap.set(
  'n',
  '<leader>dk',
  dap_ui_widgets.hover,
  { desc = '[Dap] Hover' }
)
vim.keymap.set('n', '<leader>d?', function()
  dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
end, { desc = '[Dap] Scopes' })

-- Dap virtual text
-- theHamsta/nvim-dap-virtual-text and mfussenegger/nvim-dap
vim.g.dap_virtual_text = true
require('nvim-dap-virtual-text').setup()

vim.keymap.set('n', '<leader>dui', function()
  dapui.toggle { reset = true }
end, { desc = '[Dap UI] Toggle UI' })
vim.keymap.set('n', '<leader>duio', function()
  dapui.open { reset = true }
end, { desc = '[Dap UI] Open' })
vim.keymap.set('n', '<leader>duic', dapui.close, { desc = '[Dap UI] Close' })
vim.keymap.set('n', '<leader>duir', function()
  dapui.close()
  dapui.open { reset = true }
end, { desc = '[Dap UI] Reset' })

-- Dap ui: https://github.com/rcarriga/nvim-dap-ui
dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
