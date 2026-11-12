#! /bin/sh
SESSION="titan"
if ! tmux -L default attach-session -t ${SESSION}; then
  tmux new-session -d -s ${SESSION} 'irssi'
  tmux rename-window 'irssi'
  tmux new-window -t ${SESSION}
  tmux send-keys -t "${SESSION}" \
    "neomutt" C-m
  tmux new-window -t ${SESSION}
  tmux send-keys -t "${SESSION}" \
    "anki"
  tmux select-window -t 'irssi'
  exec ${0}
fi
