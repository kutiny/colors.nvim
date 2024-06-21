# 🌈 colors.nvim

## Purpose

I have a deep appreciation for using different themes, and my initial method for switching themes involved modifying the plugin configuration directly. In the best-case scenario, I utilized the `:Telescope colorscheme` command.

To improve this process, I developed a custom function that allowed me to manually input the theme name and apply the corresponding configuration.

Ultimately, I decided to create a plugin that can list themes within a buffer, enabling me to select and apply a theme from that interface directly.

That's how colors.nvim idea was born.

## Key features

- [x] Persistent theme configuration
- [x] Hard-coded theme list
- [x] Single lua file configuration, using `name` key for plugins (using Lazy.nvim) (See [using file for listing themes](#using-file-for-listing-themes))
- [x] Fallback default theme
- [x] Enable transparent background (See [transparent-backgrounds](#transparent-backgrounds))

## Configuration

<details>
<summary>Lazy.nvim</summary>

Example configuration with Lazy.nvim

```lua
{
    'kutiny/colors.nvim',
    config = function()
        require('colors'):setup({
            enable_transparent_bg = true,
            fallback_theme_name = 'evergarden',
            file = "~/.config/nvim/lua/plugins/colors.lua", -- or use theme_list
            theme_list = { -- or use file
                'evergarden',
                'catppuccin-mocha',
                'rose-pine',
            },
            border = 'double', -- single or none
            title = ' My Themes ',
            width = 100,
            height = 20,
            title_pos = 'left', -- left, right or center
        })

        vim.keymap.set('n', '<leader>t', ':ShowThemes<CR>', { silent = true })
    end
}
```

</details>

### Using file for listing themes

If both `file` and `theme_list` configurations are present, the plugin will use the hard-coded list.

In order to use your lua configuration file (as I do) you rather prefer using file configuration, that takes a file path.
This .lua file has every theme configuration, and each theme must use the key configuration of `name`, for example:

```lua
return {
    {
        'kutiny/colors.nvim',
        config = function()
            require('colors').setup({
                enable_transparent_bg = true,
                fallback_theme_name = 'dracula',
                file = "~/.config/nvim/lua/plugins/colors.lua",
            })
        end
    },
    {
        'dracula/vim',
        name = 'dracula',
        priority = 1000,
    },
    {
        'Mofiqul/vscode.nvim',
        name = 'vscode',
        priority = 1000,
    },
    {
        'comfysage/evergarden',
        priority = 1000,
        name = 'evergarden',
    },
}
```

## Transparent Backgrounds

This plugin uses the following configuration in order to enable transparent backgrounds.

```lua
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
```

