local M = {}

function M:get_config(user_config)
    local default_config = {
        enable_transparent_bg = false,
        hide_builtins = true,
        border = 'single',
        title = ' My Themes ',
        width = 70,
        height = 8,
        title_pos = 'center',
        callback_fn = function () end,
    }

    return vim.tbl_extend('keep', user_config or {}, default_config)
end

return M
