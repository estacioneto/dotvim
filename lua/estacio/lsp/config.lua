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

local lspconfig = require 'lspconfig'
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- LSP servers that must have document formatting capabilities disabled
-- local disable_format_servers = { 'lua_ls', 'tsserver' }
local disable_format_servers = { 'lua_ls', 'tsserver' }

-- LSP servers that offer document formatting capabilities
local enable_format_servers = { 'luaformatter', 'prettier', 'erlangls' }

function _G.lsp_rename_apply(win)
  local new_name = vim.trim(vim.fn.getline '.')
  vim.api.nvim_win_close(win, true)
  vim.cmd 'stopinsert|normal! l'

  vim.lsp.buf.rename(new_name)
end

function _G.lsp_rename_abort(win)
  vim.api.nvim_win_close(win, true)
end

local function lsp_rename()
  -- Move the cursor to the beginning of the word
  vim.cmd [[normal viwbv]]

  local col, row = vim.fn.col '.', vim.fn.line '.' - vim.fn.line 'w0'

  -- Get cursor distance from the beginning of the word
  local window_opts = {
    relative = 'win',
    row = row - 1,
    -- Sidebar is the offset
    col = col + 4,
    win = vim.api.nvim_get_current_win(),

    width = 30,
    height = 1,
    style = 'minimal',
    border = 'rounded',
    title = 'Rename',
  }

  local cword = vim.fn.expand '<cword>'
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, window_opts)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
  for _, mode in ipairs { 'n', 'i', 'v' } do
    vim.keymap.set(
      mode,
      '<C-c>',
      string.format('<cmd>lua lsp_rename_abort(%d)<CR>', win),
      { silent = true, buffer = buf }
    )
    vim.keymap.set(
      mode,
      '<CR>',
      string.format('<cmd>lua lsp_rename_apply(%d)<CR>', win),
      { silent = true, buffer = buf }
    )
  end
end

local function setup_mappings_and_cmp(client, opts)
  local function quickfix()
    if vim.fn.exists ':EslintFixAll' ~= 0 then
      vim.cmd 'EslintFixAll'
    else
      vim.lsp.buf.code_action {
        context = { only = { 'quickfix' } },
        filter = function(a)
          return a.isPreferred
        end,
        apply = true,
      }
    end
  end

  local function format(format_opts)
    if
      not format_opts.range
      and client.server_capabilities.documentFormattingProvider
    then
      return vim.lsp.buf.format()
    end

    if
      format_opts.range
      and client.server_capabilities.documentRangeFormattingProvider
    then
      return vim.lsp.buf.range_formatting()
    end

    return vim.cmd.Format()
  end

  local fzf = require 'fzf-lua'

  -- See https://www.reddit.com/r/neovim/comments/nytu9c/how_to_prevent_focus_on_floating_window_created/
  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gd', function()
    fzf.lsp_definitions { jump_to_single_result = true }
  end, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gr', fzf.lsp_references, opts)

  -- Inlay hints
  vim.keymap.set('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, vim.tbl_extend('keep', opts, { desc = '[LSP] Toggle inlay hints' }))
  -- Enable inlay hints by default
  vim.lsp.inlay_hint.enable(true)

  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', lsp_rename, opts)
  vim.keymap.set('n', '<leader>rf', function()
    if vim.fn.exists ':RenameFile' ~= 0 then
      vim.cmd 'RenameFile'
      return
    end

    require('estacio.lsp.utils').rename_file()
  end, opts)

  vim.keymap.set('n', '<leader>oi', function()
    if vim.fn.exists ':OrganizeImports' ~= 0 then
      vim.cmd 'OrganizeImports'
      return
    end
  end)
  vim.keymap.set({ 'n', 'x' }, '<leader>ee', function()
    quickfix()
  end, opts)

  -- vim.keymap.set('n', '<leader>fmt', function() vim.lsp.buf.format({ async = true }) end, opts)

  -- Set some keybinds conditional on server capabilities
  vim.keymap.set('n', '<leader>fmt', function()
    format { range = false }
  end, vim.tbl_extend('keep', opts, { desc = 'Format' }))
  vim.keymap.set('v', '<leader>fmt', function()
    format { range = true }
  end, opts)

  vim.keymap.set('n', '<leader>fx', vim.lsp.buf.code_action, opts)

  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[c', function()
    vim.diagnostic.goto_prev()
    vim.cmd 'norm zz'
  end, opts)
  vim.keymap.set('n', ']c', function()
    vim.diagnostic.goto_next()
    vim.cmd 'norm zz'
  end, opts)

  local cmp = require 'cmp'

  cmp.setup {
    sources = {
      { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert {
      -- Enter key confirms completion item
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          cmp.confirm { select = true }
        else
          fallback()
        end
      end,

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
end

local function on_attach(client, buffer)
  if vim.tbl_contains(enable_format_servers, client.name) then
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes = 100
  end

  if vim.tbl_contains(disable_format_servers, client.name) then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local opts = { buffer = buffer }

  setup_mappings_and_cmp(client, opts)
end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

local default_setup = function(server_name)
  local config = make_config()

  if server_name == 'sumneko_lua' or server_name == 'lua_ls' then
    config = vim.tbl_extend('force', config, require 'estacio.lsp.lua')
  end

  if server_name == 'tsserver' then
    config = vim.tbl_extend('force', config, require 'estacio.lsp.typescript')
  end

  lspconfig[server_name].setup(config)
end

require('mason').setup {
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
}

require('mason-lspconfig').setup {
  ensure_installed = {
    'tsserver',
    'eslint',
    'bashls',

    'lua_ls',
  },
  handlers = { default_setup },
}
