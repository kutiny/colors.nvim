local utils = require('colors.utils')
local augroup = require('colors.autocmd')

local Buffer = {}

---Initiallize the buffer
---@param state PluginState
---@param fallback_theme string
function Buffer.init_buffer(state, fallback_theme)
    vim.api.nvim_set_option_value('readonly', true, { buf = state.bufnr })
    vim.api.nvim_set_option_value('modifiable', false, { buf = state.bufnr })

    vim.keymap.set('n', 'q', function()
        utils.handle_exit(state, fallback_theme)
    end, { buffer = state.bufnr, silent = true })

    vim.keymap.set('n', '<Esc>', function()
        utils.handle_exit(state, fallback_theme)
    end, { buffer = state.bufnr, silent = true })

    vim.keymap.set('n', '<CR>', function()
        local theme = utils.process_change(state.config)
        utils.handle_exit(state, theme)
    end, { buffer = state.bufnr, silent = true })

    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = augroup,
        buffer = state.bufnr,
        callback = function()
            utils.process_change(state.config)
        end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        group = augroup,
        buffer = state.bufnr,
        callback = function()
            utils.handle_exit(state, nil)
        end,
    })
end

return Buffer
