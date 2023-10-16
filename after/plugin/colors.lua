-- See https://gist.github.com/ryanflorence/1381526
function RandomColorSchemeMyPicks()
  -- local mypicks = { 'codedark', 'material', 'rose-pine', 'rose-pine-moon' }
  -- TODO: Reactivate material when done with lua migration and probably coc.nvim
  local mypicks = { 'codedark', 'rose-pine', 'rose-pine-moon' }
  -- Lua being 1-indexed
  vim.g.picked_color = mypicks[1 + (vim.fn.localtime() % #mypicks)]
  local my_material_themes = { 'oceanic', 'deep ocean', 'palenight', 'darker' }

  vim.g.material_style = my_material_themes[1 + (vim.fn.localtime() % #my_material_themes)]

  vim.cmd.colo(vim.g.picked_color)
end

vim.cmd([[
command NewColor call RandomColorSchemeMyPicks()
]])

RandomColorSchemeMyPicks()
