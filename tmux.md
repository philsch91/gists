# tmux

## tmux options
```
# manage tmux sessions
tmux [-f <config-file(tmux.conf)>] # start tmux server
tmux at|attach # attach terminal to tmux session
tmux ls # list running sessions
#
tmux new -s <session-name> # start new session with name
tmux at|attach -t <session-name> # (re)attach to existing session
tmux has-session -t <session-name> # check for running session
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
Arrow # switch active pane
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
```
