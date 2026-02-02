--  https://github.com/mistweaverco/kulala.nvim/issues/788#issuecomment-3647575260

vim.api.nvim_create_autocmd('Filetype', {
  callback = function(args)
    local _, treesitter = pcall(require, 'nvim-treesitter')
    if _ == nil or not treesitter then
      -- we weren't able to import tree sitter
      return
    end

    if
      not vim.list_contains(
        treesitter.get_installed(),
        vim.treesitter.language.get_lang(args.match)
      )
    then
      -- We don't have a parser for this filetype
      return
    end
    -- Handle auto install?
    -- Handle disablement
    vim.treesitter.start(args.buf)
  end,
})

return {
  -- Code tools
  -- See https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- nvim-treesitter
      require('nvim-treesitter').install {
        'vim',
        'vimdoc',
        'lua',
        -- Tech stack
        'c',
        'typescript',
        'tsx',
        'javascript',
        'jsdoc',
        'graphql',
        'erlang',
        'go',
        'gosum',
        'gowork',
        'java',
        -- Template
        'markdown',
        'yaml',
        'http',
        'json',
        'pkl',
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    config = function()
      vim.api.nvim_set_hl(
        0,
        'TreesitterContextBottom',
        { underline = true, sp = 'grey' }
      )
      vim.api.nvim_set_hl(
        0,
        'TreesitterContextLineNumberBottom',
        { underline = true, sp = 'grey' }
      )
      vim.api.nvim_set_hl(
        0,
        'TreesitterContextLineNumber',
        vim.api.nvim_get_hl(0, { name = 'CursorLineNr' })
      )
    end,
  },

  -- Not treesitter, but highlighting
  'RRethy/vim-illuminate',

  -- Still not treesitter, but pretty-renders markdown.
  -- See https://github.com/MeanderingProgrammer/render-markdown.nvim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
}
