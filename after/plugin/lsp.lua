local lspconfig = require('lspconfig')
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
local enable_format_servers = { 'luaformatter', 'prettier' }

-- In case of using coc.nvim
local disable_mapping_servers = { 'tsserver', 'eslint' }

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';')
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'}
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
      }
    }
  }
}

local function setup_mappings_and_cmp(opts)
  local function quickfix()
    if vim.cmd.EslintFixAll ~= nil then
      vim.cmd[[EslintFixAll]]
    else
      vim.lsp.buf.code_action({
        context = { only = 'quickfix' },
        filter = function(a) return a.isPreferred end,
        apply = true
      })
    end
  end
  -- See https://www.reddit.com/r/neovim/comments/nytu9c/how_to_prevent_focus_on_floating_window_created/
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, opts)

  vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>rf', function() vim.cmd('RenameFile') end, opts)

  vim.keymap.set({'n', 'x'}, '<leader>ee', function()
    quickfix()
  end, opts)
-- vim.keymap.set('n', '<leader>fmt', function() vim.lsp.buf.format({ async = true }) end, opts)

  vim.keymap.set('n', '<leader>fx', vim.lsp.buf.code_action, opts)

  vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[c', function()
    vim.diagnostic.goto_prev()
    vim.cmd('norm zz')
  end, opts)
  vim.keymap.set('n', ']c', function()
    vim.diagnostic.goto_next()
    vim.cmd('norm zz')
  end, opts)

  local cmp = require('cmp')

  cmp.setup({
    sources = {
      {name = 'nvim_lsp'},
    },
    mapping = cmp.mapping.preset.insert({
      -- Enter key confirms completion item
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        else
          fallback()
        end
      end,

      -- Ctrl + space triggers completion menu
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
  })

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

  if not vim.tbl_contains(disable_mapping_servers, client.name) or vim.g.coc_enabled == 0 then
    local opts = { buffer = buffer }

    setup_mappings_and_cmp(opts)
  end

end

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach
  }
end


local default_setup = function(server_name)
  local config = make_config()

  if server_name == 'sumneko_lua' or server_name == 'lua_ls' then
    config.settings = lua_settings
  end

  if server_name == 'tsserver' then
    config = vim.tbl_extend('force', config, require 'estacio.lsp.typescript')
  end

  lspconfig[server_name].setup(config)
end

require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'tsserver',
    'eslint',
    'lua_ls'
  },
  handlers = { default_setup },
})

