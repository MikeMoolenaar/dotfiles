-- Home machine: Nvidia + dual monitor setup

-- Nvidia/Wayland environment variables
-- hl.env("LIBVA_DRIVER_NAME",       "nvidia")
-- hl.env("XDG_SESSION_TYPE",        "wayland")
-- hl.env("GBM_BACKEND",             "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

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

hl.on("hyprland.start", function()
    hl.exec_cmd("wayvnc 0.0.0.0")
end)
