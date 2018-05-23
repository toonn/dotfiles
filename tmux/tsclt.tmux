#! /bin/sh
SESSION="tsclt"
if ! tmux -L default attach-session -t ${SESSION}; then
  cd "$HOME/src/quintessence"
  tmux new-session -d -s ${SESSION}
  tmux send-keys -t "$SESSION:0" "vim src/*" C-m
  #tmux rename-window 'ranger'
  #tmux last-pane
  ${0}
fi
