import os
import subprocess

from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy

# Define some variables
mod = "mod4"  # Use the Super key as the main modifier
terminal = "alacritty"  # Use the default terminal emulator

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    #    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Misc and my custom cmd
    Key([mod], "x", lazy.spawn("rofi -show drun"), desc="Spawn a command launcher"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("control volume +5"), desc="Volume Up"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("control volume -5"), desc="Volume Down"),
    Key([], "XF86AudioMute", lazy.spawn("control mute x"), desc="Volume Mute"),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="playerctl"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="playerctl"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="playerctl"),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("control brightness 5+"),
        desc="Brightness Up",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("control brightness 5-"),
        desc="Brightness Down",
    ),
    Key([mod], "e", lazy.spawn("thunar"), desc="File manager"),
    Key([mod], "h", lazy.spawn("xclip"), desc="Clipboard"),
    Key([mod], "s", lazy.spawn("screenshot"), desc="Screenshot"),
    Key([mod], "t", lazy.spawn("change"), desc="Theme Change"),
    Key([mod], "b", lazy.spawn("wallset"), desc="Wallpaper Change"),
    Key([mod], "z", lazy.spawn("powermenu"), desc="Power Menu"),
]

# Groups
group_labels = ["", "", "", "", "", "", "", ""]
groups = [Group(label) for label in group_labels]

for i, group in enumerate(groups, 1):
    keys.extend(
        [
            Key(
                [mod],
                str(i),
                lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}",
            ),
            Key(
                [mod, "shift"],
                str(i),
                lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {group.name}",
            ),
        ]
    )


# Layouts
def init_layout_theme():
    return {
        "margin": 0,
        "border_width": 0,
    }


layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
]

# Widget Defaults
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=14,
    padding=2,
)
extension_defaults = [widget_defaults.copy()]

# Remove Parse text
def no_text(text):
    return ""

# # remove bar
# screens = [ Screen() ]
# Define the glyphs for your icons
launcher_icon = ""
# cpu_icon = ""
# memory_icon = "󰍛"
# thermal_icon = ""
# net_icon = "󰀂"
# bluetooth_icon = ""
# pulsevolume_icon = ""
battery_icon = ""
clock_icon = ""
# capsnum_icon = ""
powermenu_icon = "⏻"

# Bar configuration
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.TextBox(
                    text=f" {launcher_icon} ",
                    fontsize=18,
                    padding=10,
		    background="#f2f4f8",
                    foreground="#161616",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("rofi -show drun")
                    },
                ),
                #               widget.CurrentLayout(
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
		widget.Spacer(
		    background="#161616",
		    length=14,
		),
		widget.Spacer(
                    background="#161616",
                    length=14,
                ),
                widget.GroupBox(
		    use_mouse_wheel=True,
                    highlight_method="block",
                    this_current_screen_border="#161616",
                    fontsize=20,
                    foreground="#f2f4f8",
                    active="#f2f4f8",
                    margin=0,
                    margin_x=0,
                    margin_y=2,
		    padding=0,
                    padding_x=2,
                    padding_y=6,
                ),
		widget.Spacer(
                    background="#161616",
                    length=14,
                ),
		widget.Spacer(
                    background="#161616",
                    length=7,
                ),
		widget.Sep(
		    foreground="#f2f4f8",
		    linewidth=2,
		    size_percent=35,
		),
		widget.TaskList(
		    icon_size=20,
		    parse_text=no_text,
                    text_minimized="",
                    text_maximized="",
                    text_floating="",
		    highlight_method="block",
		    border="#f2f4f8",
		    padding=2,
		    padding_x=0,
                    padding_y=8,
		    margin=2,
		    borderwidth=10,
		    theme_mode="preferred",
		    theme_path="/home/lea/.icons/Tela-black",
		),
                #		widget.Spacer(background="#161616"),
                #widget.Chord(
                #    chords_colors={
                #        "launch": ("#ff0000", "#ffffff"),
                #    },
                #    name_transform=lambda name: name.upper(),
                #    foreground="#f2f4f8",
                #),
                #               widget.TextBox(
                #                   text=f" {cpu_icon} ",
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                #               widget.CPU(
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                #               widget.TextBox(
                #                   text=f" {memory_icon} ",
                # 		    fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                #               widget.Memory(
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                # 		    widget.TextBox(
                #                   text=f" {thermal_icon} ",
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                #               widget.ThermalSensor(
                #                   fontsize=14,
                #                   foreground="#f2f4f8"
                #               ),
                #               widget.TextBox(
                #                   text=f" {net_icon} ",
                #                   fontsize=14,
                #                   foreground="#f2f4f8",
                #       	    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("nm-applet")}
                #               ),
                #               widget.Net(
                #                   format='{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}',
                #                   fontsize=14,
                #                   foreground="#f2f4f8",
                # 	      	    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("nm-applet")}
                #               ),
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
                # 		    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("pasystray")}
                #               ),
                #               widget.Volume(fontsize=14),
		widget.Systray(
		    padding=10,
		    fontsize=10,
		    foreground="#f2f4f8",
		),
		widget.Spacer(
                    background="#161616",
                    length=18,
                ),
                widget.TextBox(
                    text=f" {clock_icon} ",
		    fontsize=14,
		    background="#f2f4f8",
                    foreground="#161616",
                ),
                widget.Clock(
		    format="%I:%M %p",
		    fontsize=14,
	            background="#f2f4f8",
                    foreground="#161616",
		),
                widget.TextBox(
                    text=f" {battery_icon} ",
                    fontsize=14,
                    background="#f2f4f8",
                    foreground="#161616",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "xfce4-power-manager-settings"
                        )
                    },
                ),
                widget.Battery(
                    battery=0,
                    format="{percent:2.0%} |",
                    fontsize=14,
                    background="#f2f4f8",
                    foreground="#161616",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "xfce4-power-manager-settings"
                        )
                    },
                ),
                widget.Battery(
                    battery=1,
                    format="{percent:2.0%}",
                    fontsize=14,
                    background="#f2f4f8",
                    foreground="#161616",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn(
                            "xfce4-power-manager-settings"
                        )
                    },
                ),
                widget.TextBox(
                    text=f" {powermenu_icon} ",
                    padding=10,
                    fontsize=14,
                    background="#f2f4f8",
                    foreground="#161616",
                    mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("powermenu")},
                ),
            ],
            40,  # Set height of the bar
            background="#161616",  # Set the background color
            margin=[0, 0, 0, 0],  # Set the left, top, right, and bottom margins
        ),
    ),
]

# Drag floating layouts
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="confirm"),
        Match(wm_class="dialog"),
        Match(wm_class="download"),
        Match(wm_class="error"),
        Match(wm_class="file_progress"),
        Match(wm_class="notification"),
        Match(wm_class="splash"),
        Match(wm_class="toolbar"),
        Match(wm_class="Arandr"),
        Match(wm_class="feh"),
        Match(wm_class="xfce4-terminal"),
        Match(wm_class="alacritty"),
    ],
    fullscreen_border_width=0,
    border_width=0,
)


@hook.subscribe.client_new
def set_floating(window):
    if window.window.get_wm_transient_for() or window.window.get_wm_type() in [
        "notification",
        "toolbar",
        "splash",
        "dialog",
    ]:
        window.floating = True


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.vsetup"])


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
