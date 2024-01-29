return {
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Lualine: https://github.com/nvim-lualine/lualine.nvim

      -- Since we're conditionally using coc.nvim, we only setup the lualine after we know what to show.
      local function ts_version()
        return vim.g.coc_enabled == 0 and vim.g.lualine_ts_version
          or vim.g.coc_status
          or ''
      end

      local function lsp_progress()
        return vim.g.coc_enabled == 0 and require('lsp-progress').progress()
          or ''
      end

      require('lualine').setup {
        extensions = { 'quickfix' },
        tabline = {
          lualine_a = { 'vim.fn.getcwd()' },
          lualine_b = { { 'filename', path = 1, file_status = true } },
          lualine_x = { 'filetype' },
        },
        sections = {
          lualine_a = { ts_version, 'mode' },
          lualine_c = { lsp_progress },
          lualine_x = {
            {
              'diagnostics',

              -- Table of diagnostic sources, available sources are:
              --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
              -- or a function that returns a table as such:
              --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
              sources = { 'nvim_diagnostic', 'coc' },

              -- Displays diagnostics for the defined severity types
              sections = { 'error', 'warn', 'info', 'hint' },

              diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = 'DiagnosticError', -- Changes diagnostics' error color.
                warn = 'DiagnosticWarn', -- Changes diagnostics' warn color.
                info = 'DiagnosticInfo', -- Changes diagnostics' info color.
                hint = 'DiagnosticHint', -- Changes diagnostics' hint color.
              },
              -- symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
              colored = true, -- Displays diagnostics status in color if set to true.
              update_in_insert = false, -- Update diagnostics in insert mode.
              always_visible = false, -- Show diagnostics even if there are none.
            },
          },
        },
      }

      -- listen lsp-progress event and refresh lualine
      vim.api.nvim_create_augroup('lualine_augroup', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'lualine_augroup',
        pattern = 'LspProgressStatusUpdated',
        callback = require('lualine').refresh,
      })
    end,
  },
  'arkav/lualine-lsp-progress',
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end,
  },
}
