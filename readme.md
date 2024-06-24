# 🌈 colors.nvim

## Purpose

I have a deep appreciation for using different themes, and my initial method for switching themes involved modifying the plugin configuration directly. In the best-case scenario, I utilized the `:Telescope colorscheme` command.

To improve this process, I developed a custom function that allowed me to manually input the theme name and apply the corresponding configuration.

Ultimately, I decided to create a plugin that can list themes within a buffer, enabling me to select and apply a theme from that interface directly.

That's how colors.nvim idea was born.

## Key features

- [x] Persistent theme configuration
- [x] Hard-coded theme list
- [x] Fallback default theme
- [x] Enable transparent background (See [transparent-backgrounds](#transparent-backgrounds))
- [x] Prevent opening multiple menu buffers
- [x] Close menu on bufleave
- [x] Callback to run after configuring a theme (useful for reconfiguring plugins like lualine)

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
            theme_list = { -- or leave nil to use auto list
                'evergarden',
                'catppuccin-mocha',
                'rose-pine',
            },
            hide_builtins = true,
            border = 'double', -- single or none
            title = ' My Themes ',
            width = 100,
            height = 20,
            title_pos = 'left', -- left, right or center
            callback_fn = function()
                require('lualine').setup()
            end
        })

        vim.keymap.set('n', '<leader>t', ':ShowThemes<CR>', { silent = true })
    end
}
```

</details>

## Transparent Backgrounds

This plugin uses the following configuration in order to enable transparent backgrounds.

```lua
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
```

# Known Issues

## LuaLine colors are wrong after switching themes

I use lualine in my config and I noticed that lualine colors are missing or wrong after configuring a new theme.
The solution was to re-configure lualine in the callback_fn configuration
```lua
{
    'kutiny/colors.nvim',
    config = function()
        require('colors').setup({
            ...
            callback_fn = function()
                require('lualine').setup()
            end
            ...
        })
    end
}
```
