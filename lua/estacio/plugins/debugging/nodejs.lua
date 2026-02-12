return {
  {
    name = 'Launch',
    type = 'pwa-node',
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
    type = 'pwa-node',
    request = 'attach',
    address = '127.0.0.1',
    port = 9229,
    protocol = 'inspector',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'pwa-node',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
  {
    name = 'Run Jest',
    type = 'pwa-node',
    request = 'launch',
    runtimeArgs = {
      '--inspect-brk',
      '${workspaceRoot}/node_modules/.bin/jest',
      '--runInBand',
      '--no-cache',
    },
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
  }
}
