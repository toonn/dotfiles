function iv
  set -q argv[1]; or set argv (clipboard);
  printf -- $argv
  printf '\n'
  mpv --keep-open=yes $argv
end
