-- See https://gist.github.com/ryanflorence/1381526
local function RandomColorSchemeMyPicks()
  local mypicks = {
    'codedark',
    'material::oceanic',
    'material::deepocean',
    'material::palenight',
    'material::darker',
    'rose-pine',
    'rose-pine-moon',
    'catppuccin',
-- 'catppuccin-latte', -- White colorscheme
    'catppuccin-frappe',
    'catppuccin-macchiato',
    'catppuccin-mocha'
  }

  -- Lua being 1-indexed
  vim.g.picked_color = mypicks[1 + (vim.fn.localtime() % #mypicks)]

  local separator_index = string.find(vim.g.picked_color, '::')
  if separator_index then
    local full_color = vim.g.picked_color

    vim.g.picked_color = string.sub(full_color, 1, separator_index - 1)
    vim.g.material_style = string.sub(full_color, separator_index + 2, #full_color)

  end

  vim.cmd.colo(vim.g.picked_color)
end

RandomColorSchemeMyPicks()
