local Config = {}

---@alias CallbackFn fun()
---@alias UserConfiguration {enable_transparent_bg: boolean?, hide_builtins: boolean?, append_themes: string[]?, ignore_themes: string[]?, icon: string?, theme_list: string[]|nil, border: 'single'|'double'|'rounded'|'none'|string[]|nil, title: string?, width: integer?, height: integer?, title_pos: 'left'|'right'|'center'|nil, callback_fn: CallbackFn|nil}
---@alias ColorsConfiguration {enable_transparent_bg: boolean, hide_builtins: boolean, append_themes: string[], ignore_themes: string[], theme_list: string[]|nil, border: 'single'|'double'|'rounded'|'none'|string[], title: string, icon: string, width: integer, height: integer, title_pos: 'left'|'right'|'center', callback_fn: CallbackFn}

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
        icon = '',
        width = 70,
        height = 8,
        title_pos = 'center',
        callback_fn = function() end,
    }

    local conf = vim.tbl_extend('keep', user_config or {}, default_config)

    if string.len(conf.icon) > 1 then
        conf.icon = conf.icon .. ' '
    end

    return conf
end

return Config
