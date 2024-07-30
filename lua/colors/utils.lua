local builtin_themes = require("colors.builtin_themes")
local Utils = {}
local home = os.getenv("HOME")
local os_path_separator = package.config:sub(1, 1)

-- windows home path
if os_path_separator == '\\' then
    home = os.getenv("USERPROFILE")
end

local theme_file = home .. os_path_separator .. ".nvim_theme"

---Handle exit
---Set theme and close the window
---@param state PluginState
---@param theme string?
function Utils.handle_exit(state, theme)
    state.window_is_open = false
    Utils.set_colorscheme(theme, state.config, true)

    if state.config.callback_fn then
        state.config.callback_fn()
    end

    vim.api.nvim_win_close(state.win_id, true)
end

---Process a cursor update on window
---@param config ColorsConfiguration
function Utils.process_change(config)
    local line = vim.api.nvim_get_current_line()
    local theme = string.gsub(line, config.icon, '')

    Utils.set_colorscheme(theme, config, true)

    if config.callback_fn then
        config.callback_fn()
    end

    return theme
end

---Get the theme list
---@param config ColorsConfiguration
---@return string[]
function Utils.get_theme_list(config)
    if config.theme_list then
        return config.theme_list
    end

    local themes = vim.fn.getcompletion('', 'color')
    local show_themes = {}
    local ignore_themes = {}

    for k = 1, #config.ignore_themes do
        ignore_themes[config.ignore_themes[k]] = true
    end

    if config.hide_builtins then
        for k = 1, #themes do
            if not builtin_themes[themes[k]] and not ignore_themes[themes[k]] then
                show_themes[#show_themes + 1] = themes[k]
            end
        end
    else
        for k = 1, #themes do
            if not ignore_themes[themes[k]] then
                show_themes[#show_themes + 1] = themes[k]
            end
        end
    end

    if config.append_themes then
        for k = 1, #config.append_themes do
            show_themes[#show_themes + 1] = config.append_themes[k]
        end
    end

    return show_themes
end

---Reads theme file and returns the configured theme
---@return string|nil
local function get_saved_theme()
    local theme = nil
    local file = io.open(theme_file, "r")
    if file then
        theme = file:read("*l")
        file:close()
    end
    return theme
end

---Saves the theme to disk
---@param theme string
local function save_theme_to_disk(theme)
    local file = io.open(theme_file, 'w+')
    if file then
        file:write(theme)
        file:close()
    else
        print('[Colors]: Failed to save theme')
    end
end

---Sets the selected theme
---@param color string?
---@param config table<string, any>
function Utils.set_colorscheme(color, config, execute_callback)
    if color then
        save_theme_to_disk(color)
    else
        color = get_saved_theme()
    end

    if color == "" or color == nil then
        color = config.fallback_theme_name
    end

    vim.cmd.colorscheme(color)

    if config.enable_transparent_bg then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    if config.callback_fn and execute_callback then
        config.callback_fn()
    end
end

return Utils
