# tmux

## tmux options
```
tmux attach # reattach to tmux session
tmux new -s <session-name> # start new session with name
tmux has-session -t <session-name> # check for running session
tmux ls # list running sessions
tmux [-f <config-file(tmux.conf)>]
tmux -V # print version info
```

## tmux key bindings
```
Ctrl+b ? # list key bindings
Ctrl+b c # create new tmux window
Ctrl+b d # detach from tmux session
Ctrl+b S # view sessions, windows and panes
Ctrl+b " # break current pane into two, top and bottom
Ctrl+b % # break current pane into two, left and right
Ctrl+b $ # rename current session
Ctrl+b , # rename current window
Ctrl+b & # kill current window
Ctrl+b ( # switch attached client to previous session
Ctrl+b ) # switch attached client to next session
Ctrl+b 0/9 # select tmux windows 0 to 9
Ctrl+b n # select next window
Ctrl+b p # select previous window
Ctrl+b i # display window information
Ctrl+b t # display time
Ctrl+b w # select window interactively
Ctrl+b [ # enter scroll mode
Ctrl+b Q # leave scroll mode
Arrow # switch active pane
Alt+Arrow # resize active pane
```

## tmux files
- `/etc/tmux.conf`<br />
- `~/.tmux.conf`<br />

## tmux directories

## tmux.conf
```
set -g history-limit 10000
set -g status-interval 1
set -g status-left '#H#[default]'
set -g status-right '#(cut -d ” ” -f 1-4 /proc/loadavg)#[default] #%Y-%m-%d %H:%M:%S#[default]'
setw -g monitor-activity on
set -g visual-activity on
# set -g mouse on

# X11 selection
# xclip local
set-environment -g DISPLAY :0.0
# paste-buffer in X11 selection
bind C-c run "tmux show-buffer | xclip -i -selection primary" # Ctrl+b Ctrl+c
# X11 selection in tmux paste-buffer
bind C-v run "tmux set-buffer -- \"$(xclip -o -selection primary)\"; tmux paste-buffer" # Ctrl+b Ctrl+v
```
