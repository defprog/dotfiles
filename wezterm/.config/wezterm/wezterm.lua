local wezterm = require 'wezterm'
local config = wezterm.config_builder()


config.default_prog       = { '/usr/bin/nu' }
config.window_decorations = 'NONE'
config.color_scheme       = 'tokyonight_night'
-- config.colors             = {
-- 	background = "#000000",
-- }
config.font_size          = 9
config.font               = wezterm.font('Hack Nerd Font')


config.keys = {
	{ key = 'LeftArrow',  mods = 'ALT',       action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
	{ key = 'RightArrow', mods = 'ALT',       action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
	{ key = 'UpArrow',    mods = 'ALT',       action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
	{ key = 'DownArrow',  mods = 'ALT',       action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
	{ key = 'Enter',      mods = 'ALT',       action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	{ key = 'Enter',      mods = 'ALT|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
	{ key = 'h',          mods = 'ALT',       action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'l',          mods = 'ALT',       action = wezterm.action.ActivatePaneDirection 'Right' },
	{ key = 'k',          mods = 'ALT',       action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'j',          mods = 'ALT',       action = wezterm.action.ActivatePaneDirection 'Down' },
	{ key = 'z',          mods = 'ALT',       action = wezterm.action.TogglePaneZoomState },
}

local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')
tabline.setup({
	options = {
		theme = 'tokyonight_night',
	}
})
tabline.apply_to_config(config)

return config
