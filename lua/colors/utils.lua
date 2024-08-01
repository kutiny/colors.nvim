local builtin_themes = require("colors.builtin_themes")
local Utils = {}
local home = os.getenv("HOME")
local os_path_separator = package.config:sub(1, 1)
local uv = vim.loop
local group = require('colors.autocmd')

-- windows home path
if os_path_separator == '\\' then
    home = os.getenv("USERPROFILE")
end

local theme_file = home .. os_path_separator .. ".nvim_theme"

---Handle exit
---Set theme and close the window
---@param state PluginState
---@param theme string?
---@param skip_save boolean?
function Utils.handle_exit(state, theme, skip_save)
    state.window_is_open = false
    Utils.set_colorscheme(theme, state.config, skip_save, true)

    if state.config.callback_fn then
        state.config.callback_fn()
    end

    vim.api.nvim_clear_autocmds({ group = group })
    vim.api.nvim_win_close(state.win_id, true)
end

---Process a cursor update on window
---@param config ColorsConfiguration
function Utils.process_change(config)
    local line = vim.api.nvim_get_current_line()
    local theme = string.gsub(line, config.icon, '')

    Utils.set_colorscheme(theme, config, true, true)

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

---Reads theme file asynchronous and execute the callback
---@return nil
local function get_saved_theme(callback)
    local theme = nil
    uv.fs_open(theme_file, "r", 438, function(err, fd)
        assert(not err, err)
        uv.fs_fstat(fd, function(err, stat)
            assert(not err, err)
            uv.fs_read(fd, stat.size, 0, function(err, data)
                assert(not err, err)
                theme = data
                uv.fs_close(fd, function(err)
                    assert(not err, err)
                    vim.schedule(function()
                        callback(theme)
                    end)
                end)
            end)
        end)
    end)
end

---Saves the theme to disk
---@param theme string
local function save_theme_to_disk(theme)
    uv.fs_open(theme_file, "w", 438, function(err, fd)
        assert(not err, err)
        uv.fs_write(fd, theme, -1, function(err)
            assert(not err, err)
            uv.fs_close(fd, function(err)
                assert(not err, err)
            end)
        end)
    end)
end

---Sets the selected theme
---@param color string?
---@param config table<string, any>
---@param skip_save boolean?
function Utils.set_colorscheme(color, config, skip_save, execute_callback)
    function apply_theme(t)
        vim.cmd.colorscheme(t)
        if config.enable_transparent_bg then
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end
    end

    function read_callback(read_theme)
        if read_theme == "" or read_theme == nil then
            read_theme = config.fallback_theme_name
        end

        apply_theme(read_theme)

        if config.callback_fn and execute_callback then
            config.callback_fn()
        end
    end

    if color and not skip_save then
        save_theme_to_disk(color)
        apply_theme(color)
    elseif color then
        apply_theme(color)
    else
        get_saved_theme(read_callback)
    end
end

return Utils
