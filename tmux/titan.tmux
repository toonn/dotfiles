#! /bin/sh
SESSION="titan"
if ! tmux -L default attach-session -t ${SESSION}; then
  tmux new-session -d -s ${SESSION} # 'ranger ~/Downloads'
  tmux rename-window 'ranger'
  tmux new-window -t ${SESSION} '~/.irssi/scripts/notify-listener.py &; irssi'
  tmux rename-window 'irssi'
  #tmux split-window -t ${SESSION} -h -l 10 'cat ~/.irssi/nicklistfifo'
  tmux last-pane
  exec ${0}
fi
