local dap = require('dap')

local function debugJest()
  -- TODO: If inside a test file, run that file and ask for the config
  print("starting Jest")
  dap.run({
    type = 'node2',
    request = 'launch',
    cwd = vim.fn.getcwd(),
    runtimeArgs = { '--inspect-brk', '/usr/local/bin/jest', '--no-coverage' },
    sourceMaps = true,
    protocol = 'inspector',
    skipFiles = { '<node_internals>/**/*.js' },
    console = 'integratedTerminal',
    port = 9229,
  })
end

local function attach()
  print("attaching")
  dap.run({
    type = 'node2',
    request = 'attach',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    skipFiles = {'<node_internals>/**/*.js'},
  })
end

local function attachToRemote()
  print("attaching")
  dap.run({
    type = 'node2',
    request = 'attach',
    address = "127.0.0.1",
    port = 9229,
    localRoot = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    skipFiles = {'<node_internals>/**/*.js'},
  })
end

return {
  debugJest = debugJest,
  attach = attach,
  attachToRemote = attachToRemote,
}
