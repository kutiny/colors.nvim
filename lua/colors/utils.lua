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

    local themes = vim.fn.getcompletion('', 'color')
    local show_themes = {}
    local ignore_themes = {}

    for _, t in ipairs(config.ignore_themes) do
        ignore_themes[t] = true
    end

    if config.hide_builtins then
        local builtins = {
            ['blue'] = true,
            ['darkblue'] = true,
            ['default'] = true,
            ['delek'] = true,
            ['desert'] = true,
            ['elflord'] = true,
            ['evening'] = true,
            ['habamax'] = true,
            ['industry'] = true,
            ['koehler'] = true,
            ['lunaperche'] = true,
            ['morning'] = true,
            ['murphy'] = true,
            ['pablo'] = true,
            ['peachpuff'] = true,
            ['quiet'] = true,
            ['ron'] = true,
            ['shine'] = true,
            ['slate'] = true,
            ['torte'] = true,
            ['zellner'] = true,
        }

        for _, v in ipairs(themes) do
            if not builtins[v] and not ignore_themes[v] then
                table.insert(show_themes, v)
            end
        end
    else
        for _, v in ipairs(themes) do
            if not ignore_themes[v] then
                table.insert(show_themes, v)
            end
        end
    end

    if config.append_themes then
        for _, t in ipairs(config.append_themes) do
            table.insert(show_themes, t)
        end
    end

    return show_themes
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
