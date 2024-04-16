#! /bin/sh
PROJECT=${1}
SESSION='T8N'
SIZE=$(stty size)
ROWS="${SIZE% *}"
COLS="${SIZE#* }"
if ! tmux -L default attach-session -t "${SESSION}" 2>/dev/null; then
  cd "${PROJECT}" || exit
  tmux new-session -d -s "${SESSION}" -x "${COLS}" -y "$((ROWS - 1))"
  tmux rename-window proj
  # Tilde doesn't expand in double quotes but I don't need it to
  # shellcheck disable=SC2088
  tmux send-keys -t "${SESSION}:proj" \
    "cd ~/T8N || exit" C-m \
    "~/T8N/timer.sh" C-m
  tmux split-window -l 80%
  # shellcheck disable=SC2088
  tmux send-keys -t "${SESSION}:proj" \
    "taskell ~/T8N/T8N.md" C-m
  tmux split-window -l 60%
  # shellcheck disable=SC2088
  tmux send-keys -t "${SESSION}:proj" \
    "vim ~/T8N/T8N.timedot" C-m
  tmux new-window -t "${SESSION}"
  tmux send-keys -t "${SESSION}:1" \
    "git lg -10" C-m \
    "git st" C-m
  ${0} "${@}"
fi
