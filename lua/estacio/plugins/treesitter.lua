return {
  -- Code tools
  -- See https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- nvim-treesitter
      require('nvim-treesitter.configs').setup {
        -- A list of parser names, or 'all'
        ensure_installed = {
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
          -- Template
          'markdown',
          'yaml',
          'http',
          'json',
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- List of parsers to ignore installing (for 'all')
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          disable = {},

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
          -- disable = { 'typescript' }
        },
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
}
