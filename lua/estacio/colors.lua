-- See https://gist.github.com/ryanflorence/1381526

-- @param pick string
local function RandomColorSchemeMyPicks(pick)
  local mypicks = {
    'codedark',
    -- 'material::oceanic', -- Good one but not great
    'material::deepocean',
    'material::palenight',
    'material::darker',
    'rose-pine-main',
    'rose-pine-moon',
    'rose-pine::klarna',
    'catppuccin',
    -- 'catppuccin-latte', -- White colorscheme
    'catppuccin-frappe',
    'catppuccin-macchiato',
    'catppuccin-mocha',
    'killer-queen',
  }

  -- Lua being 1-indexed
  vim.g.picked_color = pick or mypicks[1 + (vim.fn.localtime() % #mypicks)]

  if string.find(vim.g.picked_color, 'rose%-pine') then
    if vim.g.picked_color == 'rose-pine::klarna' then
      -- See https://github.com/rose-pine/neovim/blob/main/lua/rose-pine/palette.lua
      local palette = {
        _nc = '#130925',
        -- nc = '#130925',
        base = '#160C2A',
        surface = '#1C1234',
        overlay = '#231840', -- Klarna

        muted = '#6e6a86',
        subtle = '#908caa',

        text = '#E4E3DF', -- Klarna
        love = '#FFA8CD', -- Klarna
        gold = '#DAF373', -- Klarna
        rose = '#FFD8EA', -- Klarna

        pine = '#31748f',
        foam = '#9ccfd8',

        iris = '#BEB3FF', -- Klarna
        leaf = "#95b1ac",

        highlight_low = '#1E1534',
        highlight_med = '#3D3258',
        highlight_high = '#4F446D',

        none = 'NONE',
      }

      -- FIXME
      package.loaded['rose-pine.palette'] = palette

      require('rose-pine').colorscheme()

      -- https://github.com/rose-pine/neovim/blob/main/lua/lualine/themes/rose-pine.lua
      require('lualine').setup {
        options = {
          theme = {
            normal = {
              a = { bg = palette.rose, fg = palette.base, gui = 'bold' },
              b = { bg = palette.overlay, fg = palette.rose },
              c = { bg = palette.base, fg = palette.text },
            },
            insert = {
              a = { bg = palette.foam, fg = palette.base, gui = 'bold' },
              b = { bg = palette.overlay, fg = palette.foam },
              c = { bg = palette.base, fg = palette.text },
            },
            visual = {
              a = { bg = palette.iris, fg = palette.base, gui = 'bold' },
              b = { bg = palette.overlay, fg = palette.iris },
              c = { bg = palette.base, fg = palette.text },
            },
            replace = {
              a = { bg = palette.pine, fg = palette.base, gui = 'bold' },
              b = { bg = palette.overlay, fg = palette.pine },
              c = { bg = palette.base, fg = palette.text },
            },
            command = {
              a = { bg = palette.love, fg = palette.base, gui = 'bold' },
              b = { bg = palette.overlay, fg = palette.love },
              c = { bg = palette.base, fg = palette.text },
            },
            inactive = {
              a = { bg = palette.base, fg = palette.muted, gui = 'bold' },
              b = { bg = palette.base, fg = palette.muted },
              c = { bg = palette.base, fg = palette.muted },
            },
          },
        },
      }
      return
    end

    package.loaded['rose-pine.palette'] = nil
    vim.cmd.colo(vim.g.picked_color)

    return
  end

  local separator_index = string.find(vim.g.picked_color, '::')
  if separator_index then
    local full_color = vim.g.picked_color

    vim.g.picked_color = string.sub(full_color, 1, separator_index - 1)
    vim.g.material_style =
      string.sub(full_color, separator_index + 2, #full_color)
  end

  vim.cmd.colo(vim.g.picked_color)
end

vim.api.nvim_create_user_command('Colo', function(opts)
  RandomColorSchemeMyPicks(opts.args)
end, { nargs = '?' })

RandomColorSchemeMyPicks 'rose-pine::klarna'
