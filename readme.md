# 🌈 colors.nvim

## Purpose

I have a deep appreciation for using different themes, and my initial method for switching themes involved modifying the plugin configuration directly. In the best-case scenario, I utilized the `:Telescope colorscheme` command.

To improve this process, I developed a custom function that allowed me to manually input the theme name and apply the corresponding configuration.

Ultimately, I decided to create a plugin that can list themes within a buffer, enabling me to select and apply a theme from that interface directly.

That's how colors.nvim idea was born.

## Key features

- [x] Persistent theme configuration
- [x] Hard-coded theme list
- [x] Append list
- [x] Blacklist
- [x] Fallback default theme
- [x] Enable transparent background (See [transparent-backgrounds](#transparent-backgrounds))
- [x] Callback to run after configuring a theme (useful for reconfiguring plugins like lualine)

## Configuration

<details>
<summary>Lazy.nvim</summary>

Example configuration with Lazy.nvim

```lua
{
    'kutiny/colors.nvim',
    config = function()
        require('colors').setup({
            enable_transparent_bg = true,
            fallback_theme_name = 'evergarden',
            hide_builtins = true,
        })

        vim.keymap.set('n', '<leader>t', ':ShowThemes<CR>', { silent = true })
    end
}
```

</details>

## Default configuration

```lua
{
    append_themes = {},
    border = 'single',
    callback_fn = function () end,
    enable_transparent_bg = false,
    height = 8,
    hide_builtins = true,
    ignore_themes = {},
    theme_list = nil,
    title = ' My Themes ',
    title_pos = 'center',
    width = 70,
}
```

|configuration|explanation|default|
|:-|:-|:-|
|append_themes|If you want to manually append themes to the list|{}|
|border|Window border, See [window configuration](https://neovim.io/doc/user/api.html#nvim_open_win())|rounded|
|callback_fn|Function to execute after configuring a theme|_empty function_|
|enable_transparent_bg|[See transparent backgrounds](#transparent-backgrounds)|false|
|height|Window height|8|
|hide_buildtins|Hide builtin themes from the list|true|
|ignore_themes|Remove items from list|{}|
|theme_list|Hard-coded theme list|nil|
|title_pos|Window title position, See [window configuration](https://neovim.io/doc/user/api.html#nvim_open_win())|'center'|
|title|Window title, See [window configuration](https://neovim.io/doc/user/api.html#nvim_open_win())|' Themes '|
|width|Window width|70|


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
