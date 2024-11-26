# screen

## screen options
```
screen [<command> [<arg0>...<argn>]]
screen -t "<window-title>" <terminal-number> # create session with terminal window title
screen -ls|-list # list screen session
screen -r <session-name>|<process-id> # reattach to screen session
screen -S <session-name> # create session with name
screen -v # print version number
```

## screen key bindings
```
Ctrl-a ? # list available commands and bindings
Ctrl-a c # creates a new window running a shell and switches to it
Ctrl-a " # view list of open terminals
Ctrl-a A # rename window and set title
Ctrl-a n # switch to next window
Ctrl-a p # switch to previous window
Ctrl-a <terminal-number> # switch to terminal with passed number
Ctrl-a S # split terminal window into panes
Ctrl-a [tab] # switch between terminal panes
Ctrl-a Q # exit split-pane view after selecting the pane to be left
Ctrl-a L # reset screen
Ctrl-a d # detach from screen session
Ctrl-a i # view terminal window title
Ctrl-a : # change session name
```

## screen environment variables
- `$SYSSCREENRC`<br />
- `$SCREENRC`<br />
- `$SCREENDIR`<br />

```
mkdir -pv $HOME/.local/run/screen
chmod 700 $HOME/.local/run/screen
export SCREENDIR=$HOME/.local/run/screen
```

## screen files
- `/etc/screenrc`<br />
- `/etc/etcscreenrc`<br />
- `~/.screenrc`<br />
- `/run/utmp`<br />

## screen directories
- `~/.screen/`<br />
- `/tmp/screens/`<br />
- `/run/screen/`<br />

## .screenrc
```
startup_message off

# Disable visual bell
vbell off

# Set scrollback buffer to 10000
defscrollback 10000

monitor on
info
time
caption always "%{= Wk}%-w%{= Bw}%n %t%{-}%+w %-=" # Always view terminal window title
screen -t "main" 1
screen -t "dev" 2
```
