# Minimalist AS F*vk: Autostart X if running on the first virtual terminal and in an interactive session
if status is-interactive; and test -z "$DISPLAY" -a "$XDG_VTNR" = 1; exec startx -- -keeptty; end

# Remove greeting
set fish_greeting

# Set default colors
set -g fish_color_normal black '#1b2125'
set -g fish_color_normal red '#7D8882'
set -g fish_color_normal green '#87918B'
set -g fish_color_normal yellow '#86918A'
set -g fish_color_normal blue '#89938C'
set -g fish_color_normal magenta '#89948D'
set -g fish_color_normal cyan '#8B958F'
set -g fish_color_normal white '#bdc2be'

# Set bright colors
set -g fish_color_command $fish_color_normal
set -g fish_color_quote $fish_color_normal
set -g fish_color_error red

# Set background and foreground colors
set -g fish_color_normal -b black --bold $fish_color_normal
set -g fish_color_command -b black --bold $fish_color_command
set -g fish_color_quote -b black --bold $fish_color_quote
set -g fish_color_error -b black --bold $fish_color_error
set -g fish_color_escape $fish_color_normal

# Set cursor color
set -g fish_color_cursor $fish_color_normal

# Starship prompt
starship init fish | source

# Environment variables
set -x QT_QPA_PLATFORMTHEME "gtk3"
set -x VISUAL "nvim" 
set -x EDITOR "geany" 
set -x TERM "alacritty" 
set -x HISTCONTROL "ignoredups:erasedups"
set -x XCURSOR_THEME "oreo_white_cursors xclock"

# Set other env
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CACHE_HOME "$HOME/.cache"

# Xdeb for voidlinux
set -x XDEB_OPT_DEPS "true"
set -x XDEB_OPT_SYNC "true"
set -x XDEB_OPT_WARN_CONFLICT "true"
set -x XDEB_OPT_FIX_CONFLICT "true"

# NYoom
set -x NVIM_APPNAME "nvim"

# Path my script
set -x PATH "$HOME/.config/nvim/bin:$HOME/.local/bin:$PATH"

# Change title terminal
switch $TERM
    case "xterm*" "rxvt*" "Eterm*" "aterm" "kterm" "gnome*" "alacritty" "st" "konsole*"; set -x PROMPT_COMMAND 'echo -ne "\033]0;($USER@$HOSTNAME:r):($PWD:r)\007"'
    case "screen*"; set -x PROMPT_COMMAND 'echo -ne "\033_]($USER@$HOSTNAME:r):($PWD:r)\033\\"'
end

# Navigation
function up
    set d ""
    set limit $argv[1]

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; set limit 1; end

    for i in (seq $limit); set d "../$d"; end

    # perform cd. Show error if cd fails
    if not cd "$d"; echo "Couldn't go up $limit dirs."; end
end

# Vim
alias vim 'neovim'

# Changing "ls" to "exa"
alias ls 'exa -al --color=always --group-directories-first'
alias la 'exa -a --color=always --group-directories-first'
alias ll 'exa -l --color=always --group-directories-first'
alias lt 'exa -aT --color=always --group-directories-first'
alias l. 'exa -a | egrep "^\."'

# Clear vkpurge alias
function clrk
    sudo vkpurge rm all
end

# XBPS
alias vu 'sudo xbps-install -Syuv'
alias vp 'sudo xbps-install -Sy'
alias vr 'sudo xbps-remove -Rcon'
alias vfr 'sudo xbps-remove -Rcon -F'
alias vq 'xbps-query -l'
alias vf 'vq | grep'
alias vs 'xbps-query -Rs'
alias vd 'xbps-query -x'

# Flatpak
alias fu 'flatpak update'
alias fi 'flatpak install'
alias ff 'flatpak repair'
alias fs 'flatpak search'
alias fl 'flatpak list'
alias fr 'flatpak uninstall --delete-data'
alias fc 'flatpak uninstall --unused'

# Nix
alias nu 'nix-env -u'
alias nf 'nix-env --query'
alias na 'nix-env --query "*"'
alias ni 'nix-env -i'
alias nr 'nix-env -e'
alias ns 'nix search'
alias no 'nix-env --rollback'
alias ncl 'nix-channel --list'
alias nca 'nix-channel --add'
alias ncu 'nix-channel --update'

# Arch & Paru
alias pacs 'sudo pacman -Syu'
alias paci 'sudo pacman -S --noconfirm'
alias pacr 'sudo pacman -Rs'
alias pacq 'pacman -Q'
alias pacinfo 'pacman -Qi'
alias pacfiles 'pacman -Ql'
alias paruup 'paru -Syu'
alias parui 'paru -S'
alias parur 'paru -Rs'
alias paruq 'paru -Q'
alias paruinfo 'paru -Qi'
alias parufiles 'paru -Ql'
alias unlock 'sudo rm /var/lib/pacman/db.lck'
alias cleanup 'sudo pacman -Rns (pacman -Qtdq)'

# Clear cmd
alias c 'clear'

# Get fastest mirrors
alias mirror "sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord "sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors "sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora "sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'

# Adding flags
alias df 'df -h'
alias free 'free -m'

# Ps
alias psa "ps auxf"
alias psgrep "ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem 'ps auxf | sort -nr -k 4'
alias pscpu 'ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge 'xrdb -merge ~/.Xresources'

# Git
alias addup 'git add -u'
alias addall 'git add .'
alias branch 'git branch'
alias checkout 'git checkout'
alias clone 'git clone'
alias cdepth 'git clone --depth=1'
alias addco 'git add . && git commit -s'
alias fetch 'git fetch'
alias pull 'git pull origin'
alias push 'git push origin'
alias stat 'git status'
alias tag 'git tag'
alias newtag 'git tag -a'
alias seturl 'git remote set-url origin'

# Get error messages from journalctl
alias jctl "journalctl -p 3 -xb"

# GPG encryption
# Verify signature for isos
alias gpg-check "gpg2 --keyserver-options auto-key-retrieve --verify"
# Receive the key of a developer
alias gpg-retrieve "gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# Play audio files in the current dir by type
alias playwav 'mpv *.wav'
alias playogg 'mpv *.ogg'
alias playmp3 'mpv *.mp3'

# Play video files in the current dir by type
alias playavi 'mpv *.avi'
alias playmov 'mpv *.mov'
alias playmp4 'mpv *.mp4'

# Switch between shells
alias tobash "sudo chsh $USER -s /bin/bash"
alias tozsh "sudo chsh $USER -s /bin/zsh"
alias tofish "sudo chsh $USER -s /bin/fish"

# Termbin
alias tb "nc termbin.com 9999"

# The terminal rickroll
alias rr 'curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# Countdown
function cdown
    set N $argv[1]
    while test $N -gt 0
        echo "$N" | figlet -c | lolcat; and sleep 1
        set N (math $N - 1)
    end
end

# Ssh
eval (ssh-agent -c) > /dev/null 2>&1 &

# Simple power
alias soff 'systemctl poweroff'
alias sboot 'systemctl reboot'
alias spend 'systemctl suspend'
alias ssleep 'systenctl sleep'
alias loff 'loginctl poweroff'
alias lboot 'loginctl reboot'
alias lpend 'loginctl suspend'
alias lsleep 'loginctl sleep'
