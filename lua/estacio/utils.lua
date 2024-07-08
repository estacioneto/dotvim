local M = {}

-- TODO: Extract to a module that handles all this logic
local spinner_frames =
  { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local function run_spinner(notif_data)
  if
    not notif_data
    or not notif_data.notification
    or not notif_data.spinner
  then
    return
  end

  local new_spinner = (notif_data.spinner + 1) % #spinner_frames
  local new_notif = vim.notify(nil, nil, {
    hide_from_history = true,
    icon = spinner_frames[new_spinner],
    replace = notif_data.notification,
  })

  notif_data.notification = new_notif
  notif_data.spinner = new_spinner

  vim.defer_fn(function()
    run_spinner(notif_data)
  end, 100)
end

function M.run_async_cmd(command, opts, next)
  opts = opts or {}
  opts.title = opts.title or 'Utils'

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local err_output = {}
  local output = {}

  local full_command = command
    .. (#opts.args ~= 0 and ' ' .. table.concat(opts.args, ' ') or '')
  local notif_data = {
    command = {
      notification = nil,
      spinner = 1,
    },
    stdout = {
      notification = nil,
      spinner = 1,
    },
    stderr = {
      notification = nil,
      spinner = 1,
    },
  }

  local function on_success()
    vim.notify(
      'Command executed successfully: ' .. full_command,
      vim.log.levels.INFO,
      {
        title = opts.title,
        icon = '',
        timeout = 3000,
        replace = notif_data.command.notification,
        hide_from_history = false,
      }
    )

    -- if #output ~= 0 then
    -- vim.notify(
    -- 'Full output: \n' .. table.concat(output, '\n'),
    -- vim.log.levels.INFO,
    -- {
    -- title = opts.title .. ' (' .. full_command .. ')',
    -- }
    -- )
    -- end
  end

  local function on_error(code)
    vim.notify(
      'Error executing command: ' .. full_command .. ' | Error code: ' .. code,
      vim.log.levels.ERROR,
      {
        title = opts.title,
        icon = '',
        timeout = 3000,
        replace = notif_data.command.notification,
        hide_from_history = false,
      }
    )

    -- if #err_output ~= 0 then
    -- vim.notify(
    -- 'Full output: \n' .. table.concat(err_output, '\n'),
    -- vim.log.levels.ERROR,
    -- {
    -- title = opts.title .. ' (' .. full_command .. ')',
    -- }
    -- )
    -- end
  end

  local _, pid = vim.loop.spawn(
    command,
    {
      args = opts.args,
      stdio = { nil, stdout, stderr },
    },
    vim.schedule_wrap(function(code)
      if code ~= 0 then
        on_error(code)
      else
        on_success()
      end

      notif_data.command.notification = nil

      if next then
        next(code, table.concat(output, '\n'), table.concat(err_output, '\n'))
      end
    end)
  )

  notif_data.command.notification = vim.notify(
    'Executing command: ' .. full_command .. '... (pid: ' .. pid .. ')',
    vim.log.levels.INFO,
    {
      title = opts.title,
      icon = spinner_frames[1],
      timeout = false,
      on_close = function()
        -- Additional check to avoid "No matching notification"
        notif_data.command.notification = nil
      end,
    }
  )

  run_spinner(notif_data.command)

  stdout:read_start(vim.schedule_wrap(function(err, chunk)
    assert(not err, err)
    if chunk then
      table.insert(output, chunk)

      if not notif_data.stdout.notification then
        notif_data.stdout.notification =
          vim.notify(chunk, vim.log.levels.INFO, {
            title = '[stdout] ' .. opts.title .. ' (' .. full_command .. ')',
            icon = spinner_frames[1],
            timeout = false,
            hide_from_history = false,
          })

        run_spinner(notif_data.stdout)
        return
      end

      notif_data.stdout.notification = vim.notify(chunk, vim.log.levels.INFO, {
        replace = notif_data.stdout.notification,
        hide_from_history = false,
      })
    else
      if notif_data.stdout.notification then
        vim.notify(nil, nil, {
          icon = '',
          timeout = 0,
          replace = notif_data.stdout.notification,
          hide_from_history = false,
        })
        notif_data.stdout.notification = nil
      end
      stdout:close()
    end
  end))

  stderr:read_start(vim.schedule_wrap(function(err, chunk)
    assert(not err, err)
    if chunk then
      table.insert(err_output, chunk)
      -- For Git output, this is too much
      if command == 'git' then
        return
      end

      if not notif_data.stderr.notification then
        notif_data.stderr.notification =
          vim.notify(chunk, vim.log.levels.INFO, {
            title = '[stderr] ' .. opts.title .. ' (' .. full_command .. ')',
            icon = spinner_frames[1],
            timeout = false,
          })

        run_spinner(notif_data.stderr)
        return
      end

      notif_data.stderr.notification = vim.notify(chunk, vim.log.levels.INFO, {
        replace = notif_data.stderr.notification,
        hide_from_history = false,
      })
    else
      if notif_data.stderr.notification then
        vim.notify(nil, nil, {
          icon = '',
          timeout = 0,
          replace = notif_data.stderr.notification,
          hide_from_history = false,
        })
        notif_data.stderr.notification = nil
      end
      stderr:close()
    end
  end))
end

-- Add command to kill process by pid
function M.kill_process(pid)
  vim.loop.kill(pid, 15)
end

vim.api.nvim_create_user_command('RunAsync', function(opts)
  local split_args = vim.split(opts.args, ' ')
  local command, args =
    split_args[1], vim.list_slice(split_args, 2, #split_args)

  M.run_async_cmd(command, { args = args, title = 'Command' })
end, {
  nargs = '+',
})

vim.api.nvim_create_user_command('Kill', M.kill_process, {
  nargs = 1,
})

-- From https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua#L735
function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, start_row, start_column, end_row, end_column
  local mode = vim.fn.mode()

  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, start_row, start_column, _ = unpack(vim.fn.getpos '.')
    _, end_row, end_column, _ = unpack(vim.fn.getpos 'v')
    if mode == 'V' then
      -- visual line doesn't provide columns
      start_column, end_column = 0, 999
    end
  else
    -- otherwise, use the last known visual position
    _, start_row, start_column, _ = unpack(vim.fn.getpos "'<")
    _, end_row, end_column, _ = unpack(vim.fn.getpos "'>")
  end

  -- swap vars if needed
  if end_row < start_row then
    start_row, end_row = end_row, start_row
  end
  if end_column < start_column then
    start_column, end_column = end_column, start_column
  end

  local lines = vim.fn.getline(start_row, end_row)
  local n = #lines
  if n <= 0 then
    return ''
  end

  lines[n] = string.sub(lines[n], 1, end_column)
  lines[1] = string.sub(lines[1], start_column)

  return table.concat(lines, '\n'),
    {
      start = { line = start_row, char = start_column },
      ['end'] = { line = end_row, char = end_column },
    }
end

return M
