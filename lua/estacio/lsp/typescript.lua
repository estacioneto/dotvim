-- See https://github.com/neovim/neovim/issues/20784#issuecomment-1288085253
-- Maybe later it would be worth using: https://github.com/antosha417/nvim-lsp-file-operations
local lsp_utils = require 'estacio.lsp.utils'

local function organize_imports()
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = '',
  }

  vim.lsp.buf.execute_command(params)
end

vim.cmd [[
augroup tsc\_comp

autocmd FileType typescript,typescriptreact compiler tsc | setlocal makeprg=tsc\ --build\ --pretty\ false;\ tsc\ --build\ --clean

augroup END
]]

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
  commands = {
    RenameFile = {
      function()
        local result = lsp_utils.rename_file()
        if not result then
          return
        end

        vim.lsp.buf.execute_command {
          command = '_typescript.applyRenameFile',
          arguments = {
            {
              sourceUri = result.source_file,
              targetUri = result.target_file,
            },
          },
          title = '',
        }
      end,
      description = 'Rename File',
    },
    OrganizeImports = {
      organize_imports,
      description = 'Organize Imports',
    },
  },
}
