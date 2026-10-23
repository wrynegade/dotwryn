#
# interact with the running hyprland instance
#


# run hyprland lua (hyprctl eval) with error checking
use desktop/wayland/hyprland/eval --group dotwryn

# list window addresses matching a class regex
use desktop/wayland/hyprland/get-window-addresses --group dotwryn
