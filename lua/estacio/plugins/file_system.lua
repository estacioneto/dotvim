return {
  {
    'mbbill/undotree',
    -- If lazy, it's not going to register the changes.
    lazy = false,
    keys = {
      {
        '<leader>ut',
        '<cmd>UndotreeToggle<CR>',
        desc = 'UndoTree',
        silent = true,
      },
    },
    config = function()
      if vim.fn.has 'persistent_undo' then
        local target_path = vim.fn.expand '~/.undodir'

        -- create the directory and any parent directories
        -- if the location does not exist.
        if vim.fn.isdirectory(target_path) == 0 then
          vim.fn.mkdir(target_path, 'p', 0700)
        end

        vim.opt.undodir = target_path
        vim.opt.undofile = true
      end
    end,
  },

  'stevearc/oil.nvim',
}
