-- See https://github.com/yetone/avante.nvim
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = '<TAB>',
            accept_word = false,
            accept_line = false,
            next = '<C-c><C-n>',
            prev = '<C-c><C-p>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          typescript = true,
          typescriptreact = true,
          javascript = true,
          css = true,
          python = true,

          lua = true,
          markdown = true,

          erlang = true,
          go = true,
          java = true,
          sh = function()
            return not string.match(
              vim.fs.basename(vim.api.nvim_buf_get_name(0)),
              '^%.env.*'
            )
          end,
          ['.'] = false,
          ['*'] = false,
        },

        -- copilot_node_command = '/usr/local/bin/node', -- Intel
        copilot_node_command = '/opt/homebrew/bin/node', -- Apple Silicon
        copilot_model = 'gpt-4o-copilot',
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    config = function()
      -- configs.avante
      local function tokens(num)
        return num * 1024
      end

      require('avante_lib').load()

      local ok, klarna_providers =
        pcall(require, 'estacio.plugins.providers.klarna')

      require('avante').setup(
        vim.tbl_extend('keep', ok and klarna_providers or {}, {
          provider = 'copilot:gemini',
          behaviour = {
            -- https://github.com/yetone/avante.nvim/blob/main/cursor-planning-mode.md
            enable_cursor_planning_mode = true,
            minimize_diff = true,
          },

          windows = {
            width = 50,
          },

          -- Copilot models not available by default in avante.nvim
          providers = {
            ['copilot:3.7-thought'] = {
              __inherited_from = 'copilot',
              model = 'claude-3.7-sonnet-thought',
              extra_request_body = { max_tokens = tokens(64) },
            },
            ['copilot:3.7'] = {
              __inherited_from = 'copilot',
              model = 'claude-3.7-sonnet',
              extra_request_body = { max_tokens = tokens(64) },
            },
            ['copilot:o3'] = {
              __inherited_from = 'copilot',
              model = 'o3-mini',
              extra_request_body = { max_tokens = tokens(64) },
            },
            ['copilot:gpt-4.1'] = {
              __inherited_from = 'copilot',
              model = 'gpt-4.1',
              extra_request_body = { max_tokens = tokens(256) },
            },
            ['copilot:gemini'] = {
              __inherited_from = 'copilot',
              model = 'gemini-2.5-pro',
              extra_request_body = { max_tokens = tokens(256) },
            },
          },
        })
      )

      -- views can only be fully collapsed with the global statusline
      vim.opt.laststatus = 3
    end,

    -- Improved MCPHub integration
    system_prompt = function()
      local hub = require('mcphub').get_hub_instance()
      return hub:get_active_servers_prompt()
    end,

    -- Fix for custom tools to properly load MCPHub tools
    custom_tools = function()
      local ok, mcphub_ext = pcall(require, 'mcphub.extensions.avante')
      if ok then
        return { mcphub_ext.mcp_tool() }
      end
      return {}
    end,
  },

  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim', -- Required for Job and HTTP requests
    },
    -- Remove lazy loading to ensure MCPHub is available when avante.nvim loads
    -- cmd = "MCPHub",
    build = 'npm install -g mcp-hub@latest', -- Installs required mcp-hub npm module
    config = function()
      require('mcphub').setup {
        config = vim.fn.expand '~/.vim/lua/estacio/plugins/mcphub/servers.json',
        auto_approve = true,
        -- Add any additional configuration needed for your Puppeteer server
        -- For example, you might need to specify server settings:
        -- servers = {
        --   puppeteer = {
        --     enabled = true,
        --     -- any specific puppeteer server settings
        --   }
        -- }
      }
    end,
  },
}
