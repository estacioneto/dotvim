-- https://github.com/mhartington/formatter.nvim

require('formatter').setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    html = { require('formatter.filetypes.html').prettier },
    css = { require('formatter.filetypes.css').prettier },
    json = { require('formatter.filetypes.javascript').prettier },
    typescript = { require('formatter.filetypes.typescript').prettier },
    javascript = { require('formatter.filetypes.javascript').prettier },
    typescriptreact = { require('formatter.filetypes.typescriptreact').prettier }
  }
}


-- Keymaps
vim.keymap.set('n', '<leader>fmt', function() vim.cmd[[Format]] end)