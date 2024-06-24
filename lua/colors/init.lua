local M = {}
local config = require('colors.config')
local buffer = require('colors.buffer')
local utils = require('colors.utils')

function M:open_theme_window(themes, configuration)
    if self.window_is_open then
        return
    end
    self.window_is_open = true

    local win = vim.api.nvim_list_uis()
    local width = configuration.width or 80
    local current_theme = vim.g.colors_name

    if #win > 0 and not configuration.width then
        width = math.floor(win[1].width * 0.7)
    end

    local height = configuration.height or 8
    local bufnr = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        title = configuration.title or " Themes ",
        title_pos = configuration.title_pos or "center",
        row = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        width = width,
        height = height,
        style = "minimal",
        border = configuration.border or "double",
    })

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, themes)

    buffer.init_buffer(self, bufnr, current_theme, configuration)
end

function M:setup(user_config)
    local conf = config:get_config(user_config)

    vim.api.nvim_create_user_command('ShowThemes', function()
        local theme_list = utils:get_theme_list(conf)
        M:open_theme_window(theme_list, conf)
    end, {})

    utils.set_colorscheme(self, nil, conf)
end

return M
