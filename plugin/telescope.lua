-- Telescope

local utils = require('telescope.utils')
local entry_display = require('telescope.pickers.entry_display')
local strings = require('plenary.strings')
local devicons = require('nvim-web-devicons')

local def_icon = devicons.get_icon('fname', { default = true })
local iconwidth = strings.strdisplaywidth(def_icon)

local function get_path_and_tail(filename)
  local bufname_tail = utils.path_tail(filename)
  local path_without_tail = require('plenary.strings').truncate(filename, #filename - #bufname_tail, '')
  local path_to_display = utils.transform_path({
    path_display = { 'truncate' },
  }, path_without_tail)

  return bufname_tail, path_to_display
end

local function create_path_display(opts)
  return function(_, path)
    local items = {}
    if opts.show_icon then
      items = {
        { width = iconwidth },
        { width = nil },
        { remaining = true },
      }
    else
      items = {
        { width = nil },
        { remaining = true },
      }
    end

    local displayer = entry_display.create({
      separator = ' ',
      items = items,
    })

    local tail_raw, path_to_display = get_path_and_tail(path)
    local tail = tail_raw .. ' '
    local icon, color = devicons.get_icon(tail_raw, vim.filetype.match { filename = tail_raw }, { default = true })

    if opts.show_icon then

      return displayer({
        { icon, color },
        tail,
        { path_to_display, 'TelescopeResultsComment' },
      })
    else
      return displayer({
        tail,
        { path_to_display, 'TelescopeResultsComment' },
      })
    end
  end
end

require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      'node_modules'
    },
    path_display = function(_, path)
      local displayer = entry_display.create({
        separator = ' ',
        items = {
          { width = iconwidth },
          { width = nil },
          { remaining = true },
        },
      })

      local tail_raw, path_to_display = get_path_and_tail(path)
      local tail = tail_raw .. ' '
      local icon, color = devicons.get_icon(tail_raw, vim.filetype.match { filename = tail_raw }, { default = true })

      return displayer({
        { icon, color },
        tail,
        { path_to_display, 'TelescopeResultsComment' },
      })
    end,
  },
  pickers = {
    find_files = {
      path_display = create_path_display({ show_icon = false })
    },
    git_files = {
      path_display = create_path_display({ show_icon = false })
    },
    lsp_references = {
      path_display = create_path_display({ show_icon = true })
    }
  }
}
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>wg', builtin.grep_string, {})

vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
