# Notes for Claude

## Hyprland Lua API

When working on the Hyprland config (`~/.config/hypr/*.lua`), the Lua API stubs live at:

- `/usr/share/hypr/hyprland.lua` — default config with examples of all constructs
- `/usr/share/hypr/stubs/hl.meta.lua` — full type definitions for `hl.*` (window rules, layer rules, dispatchers, settings, etc.)

Check the stubs before guessing property names — not all windowrulev2 options map 1:1 to Lua field names.
