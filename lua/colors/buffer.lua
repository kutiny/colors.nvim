local utils = require('colors.utils')
local augroup = require('colors.autocmd')
local M = {}

function M:init_buffer(bufnr, fallback_theme, config)
    vim.api.nvim_buf_set_option(bufnr, 'readonly', true)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

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

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = augroup,
        buffer = bufnr,
        callback = function()
            utils:process_change(config)
        end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        group = augroup,
        buffer = bufnr,
        callback = function()
            utils.handle_exit(self, nil, config)
        end,
    })

end

return M
