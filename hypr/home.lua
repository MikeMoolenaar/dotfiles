-- Home machine: Nvidia + dual monitor setup

-- Monitors
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080",     position = "0x0",      scale = 1 })
hl.monitor({ output = "DP-2",     mode = "2560x1440@165", position = "1920x0",   scale = 1 })

-- Headless monitor for VNC (disabled by default)
-- To enable VNC:
--   1. Comment out the disabled line below
--   2. Uncomment the HDMI-A-1 and DP-2 disable lines
hl.monitor({ output = "HEADLESS", mode = "2560x1440@60", position = "3840x1920", scale = 1 })
hl.monitor({ output = "HEADLESS", disabled = true })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })
-- hl.monitor({ output = "DP-2",     disabled = true })

-- hl.on("hyprland.start", function()
--     hl.exec_cmd("wayvnc 0.0.0.0")
-- end)

-- Workspace layout: 1-5 on HDMI-A-1 (left), 6-10 on DP-2 (right)
hl.workspace_rule({ workspace = "1",  monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "2",  monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "3",  monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4",  monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5",  monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "7",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "8",  monitor = "DP-2", default = true })
hl.workspace_rule({ workspace = "9",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })

-- Autostart apps on specific workspaces
hl.on("hyprland.start", function()
    hl.exec_cmd("firefox",   { workspace = "1 silent" })
    hl.exec_cmd("alacritty", { workspace = "8 silent" })
end)

hl.window_rule({
    name  = "firefox-workspace",
    match = { class = "firefox" },

    workspace = 1,
})

hl.window_rule({
    name  = "alacritty-workspace",
    match = { class = "alacritty" },

    workspace = 8,
})

hl.window_rule({
    name  = "rider-workspace",
    match = { class = "jetbrains-rider" },

    workspace = 9,
})
