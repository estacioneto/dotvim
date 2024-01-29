return {
  -- nvim
  {
    -- See https://github.com/folke/which-key.nvim
    'folke/which-key.nvim',
    config = function()
      -- From their docs:
      -- IMPORTANT: the timeout when WhichKey opens is controlled by the vim setting timeoutlen. Please refer to the documentation to properly set it up. Setting it to 0, will effectively always show WhichKey immediately, but a setting of 500 (500ms) is probably more appropriate.
      vim.o.timeout = true
      vim.o.timeoutlen = 1000

      require('which-key').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        plugins = {
          presets = {
            operators = false, -- adds help for operators like d, y, ...
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = false, -- default bindings on <c-w>
            nav = false, -- misc bindings to work with windows
            z = false, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
          },
        },
      }
    end,
  },

  -- See colors on the editor
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        '*',
      }, { names = false })
    end,
  },
}
