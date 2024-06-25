local Config = {}

---@alias CallbackFn fun()
---@alias UserConfiguration {enable_transparent_bg: boolean?, hide_builtins: boolean?, append_themes: string[]?, ignore_themes: string[]?, theme_list: string[]|nil, border: 'single'|'double'|'rounded'|'none'|string[]|nil, title: string?, width: integer?, height: integer?, title_pos: 'left'|'right'|'center'|nil, callback_fn: CallbackFn|nil}
---@alias ColorsConfiguration {enable_transparent_bg: boolean, hide_builtins: boolean, append_themes: string[], ignore_themes: string[], theme_list: string[]|nil, border: 'single'|'double'|'rounded'|'none'|string[], title: string, width: integer, height: integer, title_pos: 'left'|'right'|'center', callback_fn: CallbackFn}

---Joins the user configuration with defaults
---@param user_config UserConfiguration
---@return ColorsConfiguration
function Config.get_config(user_config)
    local default_config = {
        enable_transparent_bg = false,
        hide_builtins = true,
        theme_list = nil,
        append_themes = {},
        ignore_themes = {},
        border = 'rounded',
        title = ' Themes ',
        width = 70,
        height = 8,
        title_pos = 'center',
        callback_fn = function() end,
    }

    return vim.tbl_extend('keep', user_config or {}, default_config)
end

return Config
