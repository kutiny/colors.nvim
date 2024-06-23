local M = {}

local theme_file = "~/.nvim_theme"

function M:handle_exit(th, config)
    self.window_is_open = false
    M:set_colorscheme(th, config)

    if config.callback_fn then
        config.callback_fn()
    end

    vim.cmd('q')
end

function M:process_change(config)
    local t = vim.api.nvim_get_current_line()
    M:set_colorscheme(t, config)

    if config.callback_fn then
        config.callback_fn()
    end

    return t
end

function M:get_theme_list(config)
    if config.theme_list then
        return config.theme_list
    end

    local file = config.file
    local cmd = "cat " .. file .. " | grep -E ' name = .*' | grep -v -E 'cmd' | tr -d ' '"
    local output = vim.fn.system(cmd)
    local content = vim.split(output, "\n")
    local themes = {}

    for _, v in ipairs(content) do
        local start = string.find(v, '%-%-')
        if start == 1 then
            goto continue
        end

        local t = string.gsub(v, "'", "")
        t = string.gsub(t, "name=", "")
        t = string.gsub(t, ",", "")
        t = string.gsub(t, "%-%-.*", '')

        if t == "" then
            goto continue
        end

        table.insert(themes, t)

        ::continue::
    end

    return themes
end

function M:set_colorscheme(color, config)
    if color then
        vim.fn.system("echo -n " .. color .. " > " .. theme_file)
    else
        color = vim.fn.system("cat " .. theme_file .. " 2> /dev/null | tr -d '\n'")
    end

    if color == "" then
        color = config.fallback_theme_name
    end

    vim.cmd.colorscheme(color)

    if config.enable_transparent_bg then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end

    if config.callback_fn then
        config.callback_fn()
    end
end

return M
