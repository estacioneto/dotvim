-- TODO: Do we need it?
-- Ale (Lint) https://github.com/dense-analysis/ale
-- Options
vim.g.ale_completion_enabled = 1
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_lint_on_text_changed  =  'normal'
vim.g.ale_lint_on_insert_leave  =  1
vim.g.ale_virtualtext_cursor  =  1
vim.g.ale_linters  =  {
  python = { 'flake8' },
  html = { 'eslint' },
  typescript = { 'eslint', 'tsserver' },
  javascript = { 'eslint', 'flow', 'flow-language-server' },
  graphql = { 'gqlint' }
}
