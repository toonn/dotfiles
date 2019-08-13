function xa
  set -q argv[1]; or set argv (clipboard);
  mpv --vid=no --ytdl-format=bestaudio/best $argv;
end
