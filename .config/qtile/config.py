import os
import re
import socket
import subprocess
from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.dgroups import simple_key_binder
from time import sleep

# Define some variables
mod = "mod4" # Use the Super key as the main modifier
terminal = "alacritty" # Use the default terminal emulator

# Script path
screenshot = "screenshot"
powermenu = "powermenu"
volume = "volume"

# Command scripts
vup = "-i"
vdown = "-d"
vmute = "-m"
# ---

# Key bindings
keys = [
    # Default bindings
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "control"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "control"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn("dmenu_run -l 15 -c -g 3"), desc="Spawn a command using a prompt widget"),
    
    # Custom bindings
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{volume} {vup}"), desc='Volume Up'),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{volume} {vdown}"), desc='Volume Down'),
    Key([], "XF86AudioMute", lazy.spawn(f"{volume} {vmute}"), desc='Volume Mute'),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc='playerctl'),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc='playerctl'),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc='playerctl'),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 10%+"), desc='Brightness Up'),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 10%-"), desc='Brightness Down'),
    Key([mod], "e", lazy.spawn("thunar"), desc='File manager'),
    Key([mod], "h", lazy.spawn("xclip"), desc='Clipboard'),
    Key([mod], "s", lazy.spawn(f"{screenshot}"), desc='Screenshot'),
]

# Groups
groups = [Group(f"{i+1}", label="󰏃") for i in range(8)]

for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}"),
        ]
    )

# Layouts
def init_layout_theme():
    return {"margin":15,
            "border_width":0,
            }

layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme)
]

# Widget Defaults
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=14,
    padding=2,
)
extension_defaults = [widget_defaults.copy()]

# Define the glyphs for your icons
launcher_icon = "󰋜"
cpu_icon = ""
memory_icon = "󰍛"
thermal_icon = ""
net_icon = "󰀂"
bluetooth_icon = ""
pulsevolume_icon = "" 
battery_icon = ""
clock_icon = ""
capsnum_icon = ""
powermenu_icon = "⏻"

# Bar configuration
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text=f" {launcher_icon} ",
                    fontsize=14,
                    padding=5,
                    foreground="#f2f4f8",
                    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("dmenu_run -l 15 -c -g 3")}
                ),
                widget.CurrentLayout(
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.GroupBox(
                    highlight_method='block',
                    this_current_screen_border='#161616',
                    fontsize=14,
                    foreground="#f2f4f8",
                    active="bdc2be"
                ),
                widget.WindowName(
                    fontsize=14,
                    foreground="#f2f4f8"
                ),  
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                    foreground="#f2f4f8"
                ),
                widget.TextBox(
                    text=f" {cpu_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.CPU(
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.TextBox(
                    text=f" {memory_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.Memory(
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.TextBox(
                    text=f" {thermal_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.ThermalSensor(
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.TextBox(
                    text=f" {net_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8",
		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("alacritty -e nmtui")}
                ),
                widget.Net(
                    format='{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}',
                    fontsize=14,
                    foreground="#f2f4f8",
		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("alacritty -e nmtui")}
                ),
#               widget.TextBox(
#                   text=f" {bluetooth_icon} ",
#                   fontsize=14,
#                   foreground="#f2f4f8",
#               ),
#               widget.Bluetooth(fontsize=14),
#               widget.TextBox(
#                   text=f" {pulsevolume_icon} ",
#                   fontsize=14,
#                   foreground="#f2f4f8",
#               ),
#               widget.Volume(fontsize=14),
                widget.TextBox(
                    text=f" {battery_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8",
		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("xfce4-power-manager-settings")}
                ),
                widget.Battery(
    		    battery=0,
    		    format="{percent:2.0%} |",
    		    fontsize=14,
    		    foreground="#f2f4f8",
    		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("xfce4-power-manager-settings")}
		),
		widget.Battery(
    		    battery=1,
    		    format="{percent:2.0%}",
    		    fontsize=14,
    		    foreground="#f2f4f8",
    		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("xfce4-power-manager-settings")}
		),
                widget.TextBox(
                    text=f" {clock_icon} ",
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.Clock(
                    format="%I:%M %p",
                    fontsize=14,
                    foreground="#f2f4f8"
                ),
                widget.Systray(
		            padding=10,
		            fontsize=10,
                    foreground="#f2f4f8"
                 ),
		        widget.TextBox(
                    text=f" {powermenu_icon} ",
		            padding=10,
                    fontsize=14,
                    foreground="#f2f4f8",
		            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("powermenu")}
                ),
            ],
            43,  # Set height of the bar
            background="#161616",  # Set the background color
            margin=[15, 15, 0, 15],  # Set the left, top, right, and bottom margins
        ),
    ),
]

# Drag floating layouts
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  
        Match(wm_class='makebranch'),    
        Match(wm_class='maketag'),       
        Match(wm_class='ssh-askpass'),   
        Match(title='branchdialog'),     
        Match(title='pinentry'),         
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_progress'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='Arandr'),
        Match(wm_class='feh'),
        Match(wm_class='xfce4-terminal'),
        Match(wm_class='alacritty'),
    ],
    fullscreen_border_width=0,
    border_width=0
)

@hook.subscribe.client_new
def set_floating(window):
    if window.window.get_wm_transient_for() or window.window.get_wm_type() in ["notification", "toolbar", "splash", "dialog"]:
        window.floating = True

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.vsetup'])

# Configuration
focus_on_window_activation = "smart"
reconfigure_screens = True
dgroups_key_binder = None
follow_mouse_focus = True
bring_front_click = False
dgroups_app_rules = [] 
auto_fullscreen = True
wl_input_rules = None
auto_minimize = True
cursor_warp = False
wmname = "LG3D"
