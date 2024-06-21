local utils = require('colors.utils')
local M = {}

function M:init_buffer(bufnr, win_id, fallback_theme, config)
    vim.keymap.set('n', 'q', function()
        utils.handle_exit(self, fallback_theme, config)
    end, { buffer = bufnr, silent = true })

    vim.keymap.set('n', '<Esc>', function()
        utils.handle_exit(self, fallback_theme, config)
    end, { buffer = bufnr, silent = true })

    vim.keymap.set('n', '<CR>', function()
        local t = utils:process_change(config)
        utils.handle_exit(self, t, config)
    end, { buffer = bufnr, silent = true })

    vim.keymap.set('n', 'j', function()
        local line_number = vim.api.nvim_win_get_cursor(win_id)[1]
        local next_line = line_number + 1

        if next_line > vim.api.nvim_buf_line_count(bufnr) then
            next_line = 1
        end

        vim.cmd("norm" .. next_line .. 'G')
        utils:process_change(config)
    end, { buffer = bufnr, silent = true })

    vim.keymap.set('n', 'k', function()
        local cursor = vim.api.nvim_win_get_cursor(win_id)

        if cursor[1] == 1 then
            cursor[1] = vim.api.nvim_buf_line_count(bufnr)
        else
            cursor[1] = cursor[1] - 1
        end

        vim.api.nvim_win_set_cursor(win_id, { cursor[1], cursor[2] })
        utils:process_change(config)
    end, { buffer = bufnr, silent = true })
end

return M
