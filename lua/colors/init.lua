local Colors = {}
local config = require('colors.config')
local buffer = require('colors.buffer')
local utils = require('colors.utils')

---@alias PluginState {config: ColorsConfiguration, window_is_open: boolean, themes: string[], bufnr: integer, win_id: integer}

---Open themes window
---@param state PluginState
function Colors.open_theme_window(state)
    if state.window_is_open then
        return
    end
    state.window_is_open = true

    local win = vim.api.nvim_list_uis()
    local width = state.config.width or 80
    local current_theme = vim.g.colors_name

    if #win > 0 and not state.config.width then
        width = math.floor(win[1].width * 0.7)
    end

    local height = state.config.height or 8
    state.bufnr = vim.api.nvim_create_buf(false, true)
    state.win_id = vim.api.nvim_open_win(state.bufnr, true, {
        relative = "editor",
        title = state.config.title,
        title_pos = state.config.title_pos,
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = state.config.border,
    })

    local theme_list = utils.get_theme_list(state.config)
    local line_target = 1
    local content = {}
    for i = 1, #theme_list do
        content[i] = state.config.icon .. theme_list[i]
        if theme_list[i] == current_theme then
            line_target = i
        end
    end
    vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, content)
    vim.api.nvim_win_set_cursor(state.win_id, { line_target, 0 })

    buffer.init_buffer(state, current_theme)
end

---setup function
---@param user_config UserConfiguration | table<string, any>
function Colors.setup(user_config)
    if user_config and (type(user_config.setup) == 'function' or type(user_config.open_theme_window) == 'function') then
        print('****************')
        print("You've called setup with `require('colors'):setup`, you must now use `require('colors').setup instead.`")
        print('Using default configuration')
        print('****************')
    end

    ---@type PluginState
    local self = {}
    self.config = config.get_config(user_config)

    vim.api.nvim_create_user_command('ShowThemes', function()
        Colors.open_theme_window(self)
    end, {})

    utils.set_colorscheme(nil, self.config, true, true)
end

return Colors
