local oil = require 'oil'

local oil_prefix = 'oil://'

local function get_oil_win_id()
  local win_ids = vim.api.nvim_list_wins()
  for _, win_id in ipairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_name = vim.api.nvim_buf_get_name(buf_id)

    if buf_name:sub(1, #oil_prefix) == oil_prefix then
      return win_id
    end
  end

  return nil
end

local vertical_split = false

vim.keymap.set('n', '<leader>ov', function()
  local oil_win_id = get_oil_win_id()

  if oil_win_id ~= nil then
    vertical_split = false
    vim.api.nvim_win_close(oil_win_id, true)
    return
  end

  vim.cmd 'vsplit | wincmd H | vertical resize 40 | set wfh | set wfw'
  oil.open()
  vertical_split = true
end)

vim.keymap.set('n', '<leader>of', function()
  oil.open_float()
end)

oil.setup {
  keymaps = {
    -- Remove motions mapping
    ['<C-l>'] = false,
    ['<C-h>'] = false,

    ['<CR>'] = {
      callback = function()
        oil.select { vertical = vertical_split }
      end,
      desc = 'Select',
    },
    ['<C-c>'] = {
      callback = function()
        local oil_win_id = get_oil_win_id()

        if oil_win_id ~= nil then
          vertical_split = false
          vim.api.nvim_win_close(oil_win_id, true)
        else
          oil.close()
        end
      end,
      desc = 'Close',
    },
    ['<C-r>'] = 'actions.refresh',
    ['<C-v>'] = 'actions.select_vsplit',
    ['<C-s>'] = 'actions.select_split',
  },
  view_options = {
    show_hidden = true,
  },
  preview = {
    update_on_cursor_moved = true,
  },
}
