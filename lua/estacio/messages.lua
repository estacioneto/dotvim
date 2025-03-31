local function get_messages()
  local messages =
    vim.split(vim.api.nvim_cmd({ cmd = 'messages' }, { output = true }), '\n')

  return vim.tbl_filter(function(line)
    return line ~= ''
  end, messages)
end

local messages_bufnr = nil

local function open_messages()
  local messages = get_messages()

  -- Check if there is a window with the messages buffer already
  if messages_bufnr then
    vim.api.nvim_set_option_value('modifiable', true, { buf = messages_bufnr })
    vim.api.nvim_buf_set_lines(messages_bufnr, 0, -1, false, messages)
    vim.api.nvim_set_option_value('modifiable', false, { buf = messages_bufnr })
    if vim.fn.bufwinid(messages_bufnr) ~= -1 then
      return
    end
  else
    messages_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(messages_bufnr, 'buf_messages')
    vim.api.nvim_buf_set_lines(messages_bufnr, 0, -1, false, messages)
    vim.api.nvim_set_option_value('filetype', 'messages', { buf = messages_bufnr })
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = messages_bufnr })
    vim.api.nvim_set_option_value('modifiable', false, { buf = messages_bufnr })

    vim.api.nvim_create_autocmd({ 'BufWipeout', 'BufDelete' }, {
      pattern = 'bud_messages',
      callback = function()
        vim.print 'Cleaning up messages buffer'
        messages_bufnr = nil
      end,
    })
  end

  -- Create a small buffer on the bottom with the messages
  vim.api.nvim_command 'belowright 10split'
  vim.api.nvim_set_current_buf(messages_bufnr)
end

vim.api.nvim_create_user_command('Messages', open_messages, {})
vim.keymap.set(
  'n',
  '<leader>om',
  ':Messages<CR>',
  { desc = 'Open messages buffer' }
)
