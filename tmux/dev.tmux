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
for FILE in "$PROJECT.cabal" stack.yaml
do 
  if [ -f "$SRC/$PROJECT/$FILE" ]; then
    FILES="$FILES $FILE"
  fi
done
SESSION="$PROJECT"
if ! tmux -L default attach-session -t ${SESSION}; then
  cd "$SRC/$SESSION"
  tmux new-session -d -s ${SESSION} load-env-ghc fish
  tmux set-option -t ${SESSION} default-command 'load-env-ghc fish'
  #tmux new-window -n vim "vim src/* lib/*" # Doesn't leave a shell after quit
  tmux rename-window proj
  tmux send-keys -t "$SESSION:proj" \
    "echo ------------------------- $(date) -------------------------" \
    "> $HOOGLELOG" C-m \
    "hoogle server --local -p 8008 > $HOOGLELOG 2>&1 &" C-m \
    "exec vim $FILES" C-m
  #tmux send-keys -t "$SESSION:proj" "vim $FILES" C-m
  tmux new-window -n src
  tmux send-keys -t "$SESSION:src" "exec vim $DIRS" C-m
  tmux new-window -n git
  tmux send-keys -t "$SESSION:git" 'git lg -5' C-m 'git st' C-m
  #tmux rename-window 'ranger'
  #tmux last-pane
  ${0} ${@}
fi
