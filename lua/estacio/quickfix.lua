-- Inspired by: https://github.com/santhosh-tekuri/dotfiles/blob/master/.config/nvim/lua/quickfix.lua
local M = {}

local namespace = vim.api.nvim_create_namespace 'qflist'

local function get_lines(all_items_tbl)
  local lines = {}

  for _, item_tbl in ipairs(all_items_tbl) do
    local line = ''

    for _, item_part in ipairs(item_tbl) do
      line = line .. item_part[1]
    end

    table.insert(lines, line)
  end

  return lines
end

local function apply_highlights(bufnr, all_items_tbl)
  for idx, item_tbl in ipairs(all_items_tbl) do
    local col = 0

    for _, item_part in ipairs(item_tbl) do
      vim.hl.range(
        bufnr,
        namespace,
        item_part[2],
        { idx - 1, col },
        { idx - 1, col + #item_part[1] }
      )
      col = col + #item_part[1]
    end
  end
end

local TYPE_HIGHLIGHTS = {
  E = 'DiagnosticSignError',
  W = 'DiagnosticSignWarn',
  I = 'DiagnosticSignInfo',
  N = 'DiagnosticSignHint',
  H = 'DiagnosticSignHint',
}

local HIGHLIGHT_GROUPS = {
  text = 'qfText',
  filename = 'qfFilename',
  line_number = 'qfLineNr',
}

local IDENTATION = { '  ', HIGHLIGHT_GROUPS.text }

--- @class quickfix_text_info See |quickfix-window-function|
--- @field id integer
--- @field winid integer
--- @field quickfix integer
--- @field start_idx integer
--- @field end_idx integer
---
--- @param info quickfix_text_info
function M.quickfix_text(info)
  local list
  local what = { id = info.id, items = 1, qfbufnr = 1 }
  if info.quickfix == 1 then
    list = vim.fn.getqflist(what)
  else
    list = vim.fn.getloclist(info.winid, what)
  end

  -- Empty line for first filename
  local all_items_tbl = {}
  for _, item in ipairs(list.items) do
    local item_tbl = { IDENTATION }

    if item.bufnr == 0 then
      table.insert(item_tbl, { item.text, HIGHLIGHT_GROUPS.text })
    else
      table.insert(
        item_tbl,
        { '' .. item.lnum .. ': ', HIGHLIGHT_GROUPS.line_number }
      )

      local text = item.text:match '^%s*(.-)%s*$' -- trim item.text
      local hl = TYPE_HIGHLIGHTS[item.type] or HIGHLIGHT_GROUPS.text

      table.insert(item_tbl, { text, hl })
    end

    table.insert(all_items_tbl, item_tbl)
  end

  vim.schedule(function()
    apply_highlights(list.qfbufnr, all_items_tbl)
  end)

  return get_lines(all_items_tbl)
end

vim.o.quickfixtextfunc = "v:lua.require'estacio.quickfix'.quickfix_text"

---------------------------------------------------------------------------------------------

local function add_virtual_lines()
  if vim.bo[0].buftype ~= 'quickfix' then
    return
  end

  local list = vim.fn.getqflist { id = 0, winid = 1, qfbufnr = 1, items = 1 }

  vim.api.nvim_buf_clear_namespace(list.qfbufnr, namespace, 0, -1)

  local last_filename = ''

  -- workaround for:
  --      cannot scroll to see virtual line before first line
  --      see https://github.com/neovim/neovim/issues/16166
  vim.fn.winrestview { topfill = 1 }

  for idx, item in ipairs(list.items) do
    local filename = vim.fn.bufname(item.bufnr)
    filename = vim.fn.fnamemodify(filename, ':p:.')

    if filename ~= '' and filename ~= last_filename then
      last_filename = filename

      vim.api.nvim_buf_set_extmark(list.qfbufnr, namespace, idx - 1, 0, {
        virt_lines = { { { filename .. ':', HIGHLIGHT_GROUPS.filename } } },
        virt_lines_above = true,
        strict = false,
      })
    end
  end
end

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'filename as virt_lines',
  callback = add_virtual_lines,
})

return M
