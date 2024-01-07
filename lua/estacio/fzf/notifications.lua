local fzf = require 'fzf-lua'
local utils = require 'estacio.utils'

local M = {}

-- Notifications. Useful for copying the error message to the clipboard or
-- for background git commands
function M.notifications_picker()
  local success, notify = pcall(require, 'notify')
  if not success then
    return
  end

  local notifications = vim.tbl_map(function(notification)
    local icon_color = notification.level == 'ERROR' and 'red'
      or notification.level == 'WARN' and 'yellow'
      or 'green'

    local icon = fzf.utils.ansi_codes[icon_color](notification.icon)
    local level = fzf.utils.ansi_codes[icon_color](notification.level)
    local timestamp = fzf.utils.ansi_codes.grey(notification.title[2])
    local title = notification.title[1] ~= '' and notification.title[1]
      or '[No title]'

    return {
      prefix = table.concat({ timestamp, icon, level, title }, ' ') .. ' > ',
      contents = notification.message,
      preview = notification.message,
      data = notification,
    }
  end, notify.history())

  table.sort(notifications, function(a, b)
    return a.data.time > b.data.time
  end)

  fzf.fzf_exec(notifications, {
    prompt = 'Notifications > ',
    actions = {
      ['default'] = function(selected)
        vim.fn.setreg('+', table.concat(selected, '\n'))
        vim.notify(
          'Copied content to clipboard!',
          vim.log.levels.INFO,
          { title = 'Fzf' }
        )
      end,
      ['alt-q'] = fzf.actions.buf_sel_to_qf,
      ['ctrl-k'] = function(selected)
        for _, notification in ipairs(selected) do
          local pid = string.match(notification, 'pid: (%d+)')

          if pid == nil then
            goto continue
          end

          utils.kill_process(pid)

          vim.notify(
            'Killed process with pid: ' .. pid,
            vim.log.levels.INFO,
            { title = 'Fzf' }
          )

          ::continue::
        end
      end,
    },
  })
end

return M
