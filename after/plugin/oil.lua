-- vim.keymap.set('n', , function() vim.cmd('Oil --float') end, { silent = true })
local oil = require('oil')

oil.setup {
  keymaps = {
    -- Remove motions mapping
    ["<C-l>"] = false,
    ["<C-h>"] = false,

    ["<C-r>"] = "actions.refresh",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
  },
  view_options = {
    show_hidden = true
  },
  preview = {
    update_on_cursor_moved = true,
  }
}

local oil_prefix = 'oil://'

local function close_oil()
  local win_ids = vim.api.nvim_list_wins()
  for _, win_id in ipairs(win_ids) do
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_name = vim.api.nvim_buf_get_name(buf_id)

    if buf_name:sub(1, #oil_prefix) == oil_prefix then
      vim.api.nvim_win_close(win_id, true)

      return true
    end
  end
end

vim.keymap.set("n", '<leader>ov', function()
  local closed_oil = close_oil()

  if closed_oil then
    return
  end

  vim.cmd("vsplit | wincmd H | vertical resize -50")
  oil.open()
end)

vim.keymap.set("n", '<leader>of', function() oil.open_float() end)
