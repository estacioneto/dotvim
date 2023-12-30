-- Also see: https://github.com/orgs/community/discussions/41869
-- Options
vim.g.copilot_enabled = true
vim.g.copilot_node_command = '/usr/local/bin/node'
vim.g.copilot_filetypes = {
  ['*'] = false,
  typescript = true,
  javascript = true,
  lua = true,
  markdown = true,
}
