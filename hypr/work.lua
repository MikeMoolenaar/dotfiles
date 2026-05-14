-- Work machine: dual monitor + workspace layout + app autostart

-- Fallback for any connected monitor
hl.monitor({ output = "",         mode = "preferred",    position = "auto",       scale = "auto" })

-- Headless monitor for VNC (disabled by default)
-- To enable VNC:
--   1. Comment out the disabled line below
--   2. Uncomment the HDMI-A-1 and DP-2 disable lines
hl.monitor({ output = "HEADLESS", mode = "2560x1440@60", position = "3840x1920", scale = 1 })
hl.monitor({ output = "HEADLESS", disabled = true })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })
-- hl.monitor({ output = "DP-2",     disabled = true })

-- Workspace layout: 1-5 on primary (DP-2), 6-10 on secondary (HDMI-A-4)
hl.workspace_rule({ workspace = "1",  monitor = "DP-2",     default = true })
hl.workspace_rule({ workspace = "2",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "3",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "4",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "5",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "6",  monitor = "HDMI-A-4" })
hl.workspace_rule({ workspace = "7",  monitor = "HDMI-A-4" })
hl.workspace_rule({ workspace = "8",  monitor = "HDMI-A-4", default = true })
hl.workspace_rule({ workspace = "9",  monitor = "HDMI-A-4" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-4" })

-- Autostart apps on specific workspaces
hl.on("hyprland.start", function()
    hl.exec_cmd("wayvnc 127.0.0.1")
    hl.exec_cmd("[workspace 1 silent] firefox")
    hl.exec_cmd("[workspace 2 silent] slack")
    hl.exec_cmd("[workspace 8 silent] alacritty")
    hl.exec_cmd("[workspace 9 silent] ~/.local/share/JetBrains/Toolbox/apps/rider/bin/rider ~/git/ngSneleentaxi/Sneleentaxi.sln")
end)

-- Pin apps to their workspaces
hl.window_rule({
    name  = "firefox-workspace",
    match = { class = "firefox" },

    workspace = 1,
})

hl.window_rule({
    name  = "slack-workspace",
    match = { class = "slack" },

    workspace = 2,
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
