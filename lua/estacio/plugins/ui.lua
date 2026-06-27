return {
  {
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup {
        input = {
          border = 'rounded',
          win_options = {
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual',
          },
        },
        select = {
          border = 'rounded',
        },
      }
    end,
  },
}
