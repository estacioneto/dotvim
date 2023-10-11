-- nvim-dap
local dap = require('dap')

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

-- Dap telescope
require('telescope').load_extension('dap')
