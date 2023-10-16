local dapui = require('dapui')

dapui.setup()

vim.keymap.set('n', '<leader>dui', dapui.toggle)
