function xa
  set -q argv[1]; or set argv (clipboard);
  printf '%s\n' $argv
  mpv --vid=no --ytdl-format=bestaudio/best $argv;
end
