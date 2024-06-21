local M = {}

function M:get_config(user_config)
    local default_config = {
        enable_transparent_bg = false,
    }

    return vim.tbl_extend('keep', user_config or {}, default_config)
end

return M
