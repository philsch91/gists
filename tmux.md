# tmux

## Server and Client
```
ls $TMUX_TMPDIR(default:/tmp)/tmux-<uid>/default
# send signal 'USR1' to tmux server to recreate the socket
pkill -USR1 tmux
```

## tmux options
```
# manage tmux sessions
# start tmux server
tmux [-f <config-file(tmux.conf)>] [-L <socket-name>] [-S <socket-path>] [command [flags]] # default command = new-session
tmux at|attach # attach terminal to tmux session
tmux ls|list-sessions # list running sessions
#
tmux new|new-session [-A(=attach-session)] -s <session-name> # create new or attach (-A) or switch session with name
tmux attach|attach-session -t <session-name>|. [-c /path/to/new/working/dir/for/session/and/new/windows] # (re)attach to existing session
tmux has|has-session -t <session-name> # check for running session
tmux kill-session -t <session-name> # kill named session
#
tmux -V # print version info
tmux -f /dev/null list-keys # list (default) keybindings ignoring ~/.tmux-conf
# create ~/.tmux.conf with default settings
tmux show -g | cat > ~/.tmux.conf
# reload ~/.tmux.conf
tmux source-file ~/.tmux.conf
# stop all sessions
tmux kill-server
tmux display-message "#{pane_current_path}"
tmux display-message "#{session_path}"
tmux command-prompt "attach -c %1" # change tmux working dir by typing and pressing enter inside a session
```

## tmux key bindings
```
# window
Ctrl+b ? # list key bindings
Ctrl+b c # create new tmux window
Ctrl+b , # rename current window
Ctrl+b i # display window information
Ctrl+b f # find window by name
Ctrl+b w # select window interactively
Ctrl+b 0/9 # select tmux windows 0 to 9
Ctrl+b n # select next window
Ctrl+b p # select previous window
Ctrl+b & # kill current window
# session
Ctrl+b $ # rename current session
Ctrl+b d # detach from tmux session
Ctrl+b S # view sessions, windows and panes
Ctrl+b ( # switch attached client to previous session
Ctrl+b ) # switch attached client to next session
# panes
Ctrl+b " # break current pane into two, top and bottom
Ctrl+b % # break current pane into two, left and right
Ctrl+b q # show pane numbers
Ctrl+b ! # break current pane into new window
Ctrl+b o # switch to next pane
Ctrl+b Arrow # switch active pane
Ctrl+b } # swap current pane with the next one
Ctrl+b { # swap current pane with the previous one
Alt+Arrow # resize active pane
Ctrl+b x # kill current pane
Ctrl+b t # display time
# scroll/copy mode
Ctrl+b [ # enter scroll/copy mode
Ctrl+b [ + Ctrl+Space to start selecting text and move cursor to end
Ctrl+b [ + Ctrl+Space + Alt+W to copy selected text
Ctrl+b Q # leave scroll mode
# config
Ctrl+b :source-file ~/.tmux.conf # reload ~/.tmux.conf
```

## tmux files
- `/etc/tmux.conf`<br />
- `~/.tmux.conf`<br />

## tmux directories
- `$HOME/.tmux/plugins`<br />

## tmux.conf
```
set -g history-limit 50000
set -g status-interval 1
set -g status-left '#H#[default]'
set -g status-right '#(cut -d " " -f 1-3 /proc/loadavg)#[default] #%Y-%m-%d %H:%M:%S '
set -ag status-right '#(uptime | cut -d " " -f 4-5 | cut -d "," -f 1)'
setw -g monitor-activity on
set -g visual-activity on
set -g escape-time 1
##
unbind(-key) -a [-T <key-table-name>]
unbind-key -a # unbind all keys in default (prefix) table
unbind -a -T prefix
unbind -a -T root
unbind -a -T copy-mode
unbind -a -T copy-mode-vi
#
set(-option) -g <key-table-name> <keys>
set -g prefix M-w # set Alt/Option+w instead of Ctrl+b
set -g prefix C-a # set prefix to Ctrl+a instead of Ctrl+b
set -g mode-keys vi # use copy-mode-vi
#
bind(-key) [-T <key-table-name>] <keys> <command>
bind M-r source-file ~/.tmux-conf # prefix key (Ctrl+b) + Alt/Option+w to reload config
bind Space copy-mode # enter scroll/copy mode with prefix key (Ctrl+b) + Space
bind -T copy-mode-vi Escape send(-keys) -X cancel
bind -T copy-mode-vi Up     send -X cursor-up
bind -T copy-mode-vi Down   send -X cursor-down
bind -T copy-mode-vi Left   send -X cursor-left
bind -T copy-mode-vi Right  send -X cursor-right
#
#bind -T copy-mode-vi Space  send -X begin-selection
bind -T copy-mode-vi Space  if -F "#{selection_present}" "send -X clear-selection" "send -X begin-selection"
#
bind -T copy-mode-vi y      send -X copy-selection(-no-clear) # macOS + iTerm.app
bind -T copy-mode-vi y      send -X copy-pipe(-no-clear) 'pbcopy' # macOS + Terminal.app
bind -T copy-mode-vi y      send -X copy-pipe(-no-clear) 'xsel --input --clipboard' # Linux 1
bind -T copy-mode-vi y      send -X copy-pipe(-no-clear) 'xclip -i -selection clipboard' # Linux 2
bind -T copy-mode-vi Enter  send -X copy-selection-and-cancel # macOS + iTerm.app
bind -T copy-mode-vi Enter  send -X copy-pipe-and-cancel # macOS + Terminal.app
##
set -g mouse on
#
bind -n WheelUpPane copy-mode -e
bind -T copy-mode-vi WheelUpPane    send -X -N 5 scroll-up
bind -T copy-mode-vi WheelDownPane  send -X -N 5 scroll-down
bind -n MouseDrag1Pane copy-mode -M
bind -T copy-mode-vi MouseDrag1Pane    send -X begin-selection
bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection(-no-clear)|copy-pipe(-no-clear) 'pbcopy'
##
# X11 selection
# xclip local
set-environment -g DISPLAY :0.0
# paste-buffer in X11 selection
bind C-c run "tmux show-buffer | xclip -i -selection primary" # Ctrl+b + Ctrl+c
# X11 selection in tmux paste-buffer
bind C-v run "tmux set-buffer -- \"$(xclip -o -selection primary)\"; tmux paste-buffer" # Ctrl+b Ctrl+v

# Tmux Plugin Manager
# 1. Clone TPM
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# 2. Add the list of plugins and `run '~/.tmux/plugins/tpm/tpm'` in this file
# 3. Reload tmux env and config to source TPM if tmux is already running
# tmux source ~/.tmux.conf
# 4. Add plugin to the list of TPM plugins in this file
# 5. Press `prefix + I` to fetch and source plugins

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# https://github.com/tmux-plugins/tmux-resurrect
set -g @plugin 'tmux-plugins/tmux-resurrect' # persistent sessions
# https://github.com/tmux-plugins/tmux-continuum
set -g @plugin 'tmux-plugins/tmux-continuum' # save sessions automatically
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# set tmux-resurrect
set -g @resurrect-capture-pane-contents 'on' # let resurrect capture contents of your panes
#set -g @resurrect-dir '~/.tmux/resurrect'
# set tmux-continuum
set -g @continuum-boot 'on'
set -g @continuum-restore 'on' # enable continuum
set -g @continuum-save-interval '5' # save every 5 minutes

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

## tmux-resurrect

```
find $HOME -type f -name "tmux_resurrect_*.txt"
tmux_resurrect_<YYYYMMDD>T<HHMMSS>.txt
```

### tmux-resurrect files and directories

- `ls -l /home/<user>/.tmux/resurrect`
- `ls -l /home/<user>/.tmux/resurrect/last`
- `ls -l /home/<user>/.local/share/tmux/resurrect`
- `ls -l /home/<user>/.local/share/tmux/resurrect/last`
