#! /bin/sh
PROJECT=${1}
HOOGLELOG=/tmp/hoogle-"${PROJECT////+}".log
SESSION=$(basename "${PROJECT}")
SIZE=$(stty size)
ROWS="${SIZE% *}"
COLS="${SIZE#* }"
if ! tmux -L default attach-session -t "${SESSION}" 2>/dev/null; then
  cd "${PROJECT}"
  tmux new-session -d -s "${SESSION}" -x "${COLS}" -y "$((${ROWS} - 1))"
  tmux rename-window proj
  tmux send-keys -t "${SESSION}:proj" \
    \ # "echo ------------------------- $(date) -------------------------" \
    \ # "> ${HOOGLELOG}" C-m \
    \ # "hoogle server --local -p 8008 > ${HOOGLELOG} 2>&1 &" C-m \
    "lorri daemon" C-m
  tmux new-window -t "${SESSION}" -n src
  tmux send-keys -t "${SESSION}:src" "exec ~/.nix-profile/bin/vim *.hs" C-m
  tmux split-window -bv -t "${SESSION}:src"
  tmux resize-pane -t "${SESSION}:src.top" -y 10
  tmux send-keys -t "${SESSION}:src.top" "reset" C-m
  tmux send-keys -t "${SESSION}:src.top" "exec ghcid *.hs" C-m
  tmux select-pane -t "${SESSION}:src.bottom"
  ${0} "${@}"
fi
