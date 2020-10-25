#! /bin/sh
PROJECT=$1
HOOGLELOG=/tmp/hoogle-${PROJECT////+}.log
SRC=$HOME/src
DIRS=''
for DIR in src lib app 'test' tests
do 
  if [ -d "$SRC/$PROJECT/$DIR" ]; then
    DIRS="$DIRS $(find -L $SRC/$PROJECT/$DIR -type f -not -name '\.*' -printf $'\'%p\' ')"
  fi
done
FILES=''
for FILE in "$PROJECT.cabal" cabal.project* *.nix stack.yaml
do 
  if [ -f "$SRC/$PROJECT/$FILE" ]; then
    FILES="$FILES $FILE"
  fi
done
SESSION="$PROJECT"
W=$(stty size | cut -d" " -f2)
H=$(stty size | cut -d" " -f1)
if ! tmux -L default attach-session -t ${SESSION}; then
  cd "$SRC/$SESSION"
  tmux new-session -d -s ${SESSION} -x $W -y $H
  tmux rename-window lorri
  tmux send-keys -t "$SESSION:lorri" \
    "echo ------------------------- $(date) -------------------------" \
    "> $HOOGLELOG" C-m \
    "hoogle server --local -p 8008 > $HOOGLELOG 2>&1 &" C-m \
    "lorri daemon" C-m
  tmux new-window -n proj
  tmux send-keys -t "$SESSION:proj" "exec vim $FILES" C-m
  tmux new-window -n src
  tmux split-window -t "$SESSION:src" -v -b -l 20
  tmux send-keys -t "$SESSION:src.0" "ghcid" C-m
  tmux select-pane -t "$SESSION:src.1"
  tmux send-keys -t "$SESSION:src.1" "exec vim $DIRS" C-m
  tmux new-window -n git
  tmux send-keys -t "$SESSION:git" 'git lg -5' C-m 'git st' C-m
  ${0} ${@}
fi
