-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mod = {}

local function is_found(str, pattern)
	return string.find(str, pattern) ~= nil
end

local function platform()
	return {
		is_linux = is_found(wezterm.target_triple, "linux"),
		is_mac = is_found(wezterm.target_triple, "apple"),
	}
end

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

if platform().is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
end

-- Changing the color scheme:
config.term = "xterm-256color"
config.animation_fps = 60
config.max_fps = 60
config.color_scheme = "GruvboxDarkHard"

-- Adding JetBrains Mono font and set font size
config.font = wezterm.font("BlexMono Nerd Font Mono", { weight = "Regular" })
config.font_size = 14

-- Set to borderless mode
config.window_decorations = "RESIZE"

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- Set to deault rows and columns
config.initial_rows = 35
config.initial_cols = 150

-- Disable tab bar
config.enable_tab_bar = false

return config
