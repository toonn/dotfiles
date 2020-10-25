#! /bin/sh
PROJECT=$1
HOOGLELOG=/tmp/hoogle-${PROJECT////+}.log
SRC=$HOME/src
DIRS=''
for DIR in '*.hs' '*.dhall'
do 
  DIRS="$DIRS $(find -L $SRC/$PROJECT/$DIR -type f -not -name '\.*' -printf $'\'%p\' ')"
done
for DIR in Dhall filters/src
do 
  if [ -d "$SRC/$PROJECT/$DIR" ]; then
    DIRS="$DIRS $(find -L $SRC/$PROJECT/$DIR -type f -not -name '\.*' -printf $'\'%p\' ')"
  fi
done
SESSION="$PROJECT"
W=$(stty size | cut -d" " -f2)
H=$(stty size | cut -d" " -f1)
if ! tmux -L default attach-session -t ${SESSION}; then
  cd "$SRC/$SESSION"
  tmux new-session -d -s ${SESSION} -x $W -y $H
  #tmux new-window -n vim "vim src/* lib/*" # Doesn't leave a shell after quit
  tmux rename-window shake
  # entr on cabal file for hoogle?
  tmux send-keys -t "$SESSION:shake" \
    "echo ------------------------- $(date) -------------------------" \
    "> $HOOGLELOG" C-m \
    "hoogle server --local -p 8008 > $HOOGLELOG 2>&1 &" C-m \
    "lorri daemon" C-m
  tmux split-window -t "$SESSION:shake.0" -p 50
  tmux new-window -n edit
  tmux send-keys -t "$SESSION:edit" "exec vim $DIRS" C-m
  tmux new-window -n filters
  tmux send-keys -t "$SESSION:filters" "cd filters" C-m
  tmux split-window -t "$SESSION:edit.0" -b -p 20 "ghcid *.hs"
  tmux select-window -t "$SESSION:edit"
  tmux select-pane -t "$SESSION:edit.1"
  ${0} "${@}"
fi
