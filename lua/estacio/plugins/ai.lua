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
        file_types = {
          typescript = true,
          typescriptreact = true,
          javascript = true,
          css = true,
          python = true,

          lua = true,
          markdown = true,

          erlang = true,
          sh = true,
          go = true,
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
      require('avante_lib').load()

      local ok, klarna_providers =
        pcall(require, 'estacio.plugins.providers.klarna')

      require('avante').setup(
        vim.tbl_extend('keep', ok and klarna_providers or {}, {
          provider = 'copilot',
          behaviour = {
            -- https://github.com/yetone/avante.nvim/blob/main/cursor-planning-mode.md
            enable_cursor_planning_mode = true,
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
