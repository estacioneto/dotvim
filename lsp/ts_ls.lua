-- See https://github.com/neovim/neovim/issues/20784#issuecomment-1288085253
-- Maybe later it would be worth using: https://github.com/antosha417/nvim-lsp-file-operations
local lsp_utils = require 'estacio.lsp.utils'

vim.cmd [[
augroup tsc\_comp

autocmd FileType typescript,typescriptreact compiler tsc | setlocal makeprg=tsc\ --build\ --pretty\ false;\ tsc\ --build\ --clean

augroup END
]]

local inlay_hints = {
  includeInlayParameterNameHints = 'literals',
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,

  includeInlayVariableTypeHints = false,
  includeInlayFunctionParameterTypeHints = false,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = false,
}

local lsp_name = 'ts_ls'

local function organize_imports()
  local clients = vim.lsp.get_clients { name = lsp_name }
  if #clients == 0 then
    vim.notify('No TypeScript server running', vim.log.levels.ERROR)
    return
  elseif #clients > 1 then
    -- In case of multiple clients, notify the user to specify which one to use
    vim.notify(
      'Multiple TypeScript servers running, please specify one',
      vim.log.levels.ERROR
    )
    return
  end

  local client = clients[1]

  client:exec_cmd(
    {
      title = 'organize_imports',
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
    },
    nil,
    function(err)
      if err then
        vim.notify(
          'Error organizing imports: ' .. err.message,
          vim.log.levels.ERROR
        )
        return
      end

      vim.cmd.Format()
    end
  )
end

local function rename_file()
  local result = lsp_utils.rename_file()
  if not result then
    return
  end

  local clients = vim.lsp.get_clients { name = lsp_name }

  if #clients == 0 then
    vim.notify('No TypeScript server running', vim.log.levels.ERROR)
    return
  elseif #clients > 1 then
    -- In case of multiple clients, notify the user to specify which one to use
    vim.notify(
      'Multiple TypeScript servers running, please specify one',
      vim.log.levels.ERROR
    )
    return
  end

  local client = clients[1]

  client:exec_cmd {
    title = 'apply_rename_file',
    command = '_typescript.applyRenameFile',
    arguments = {
      {
        sourceUri = result.source_file,
        targetUri = result.target_file,
      },
    },
  }
end

return {
  filetypes = {
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'javascript',
  },
  handlers = {
    ['$/typescriptVersion'] = function(err, result)
      if err ~= nil then
        return
      end

      vim.g.lualine_ts_version = 'TSC: ' .. result.version
    end,
  },
  settings = {
    typescript = {
      npm = 'yarn',
      inlayHints = inlay_hints,
    },
    javascript = {
      npm = 'yarn',
      inlayHints = inlay_hints,
    },
    implicitProjectConfiguration = {
      checkJs = true,
    },
  },
  init_options = {
    hostInfo = 'neovim',
    maxTsServerMemory = 9216,
    preferences = {
      quotePreference = 'single',
      importModuleSpecifierPreference = 'relative',
    },
  },
  setup_user_commands = function()
    vim.api.nvim_create_user_command('LspOrganizeImports', organize_imports, {
      desc = 'Organize Imports',
      nargs = '?',
    })

    vim.api.nvim_create_user_command('LspRenameFile', rename_file, {
      desc = 'Rename File',
      nargs = '?',
    })
  end,
}
