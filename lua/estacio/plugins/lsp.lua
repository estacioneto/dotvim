return {
  -- LSP Zero: https://github.com/VonHeikemen/lsp-zero.nvim
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      --- Uncomment these if you want to manage LSP servers from neovim
      { 'mason-org/mason.nvim' },
      { 'mason-org/mason-lspconfig.nvim' },

      -- Autocompletion
      {
        'hrsh7th/nvim-cmp',
        config = function()
          local cmp = require 'cmp'

          cmp.setup {
            sources = {
              { name = 'nvim_lsp' },
            },
            mapping = cmp.mapping.preset.insert {
              -- Enter key confirms completion item
              -- ['<CR>'] = function(fallback)
              --   if cmp.visible() then
              --     cmp.confirm { select = true }
              --   else
              --     fallback()
              --   end
              -- end,

              -- Ctrl + space triggers completion menu
              ['<C-Space>'] = cmp.mapping.complete(),
            },
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
          }

          -- if you want insert `(` after select function or method item
          -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
      },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    },
  },

  {
    'folke/trouble.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  -- Formatting
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>fmt',
        function()
          require('conform').format {
            async = false,
            timeout_ms = 3000,
            lsp_format = 'first',
          }
        end,
        desc = 'Format (conform.nvim)',
      },
    },
    config = function()
      local conform = require 'conform'

      conform.setup {
        log_level = vim.log.levels.WARN,
        notify_on_error = true,
        notify_no_formatters = true,
        formatters_by_ft = {
          lua = { 'stylua' },
          sh = { 'shfmt' },

          typescript = { 'prettier' },
          javascript = { 'prettier' },
          typescriptreact = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          json = { 'prettier' },
        },
      }

      vim.api.nvim_create_user_command('Format', function()
        conform.format {
          async = false,
          timeout_ms = 3000,
          lsp_format = 'fallback',
        }
      end, { nargs = 0 })
    end,
  },
}
