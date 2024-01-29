local signs = {
  Error = '󰅚', -- x000f015a
  Warn = '󰀪', -- x000f002a
  Info = '󰋽', -- x000f02fd
  Hint = '󰌶', -- x000f0336
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, linehl = '', numhl = '' })
end
