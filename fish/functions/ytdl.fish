function ytdl
  set -q argv[1]; or set argv (clipboard);
  echo $argv; youtube-dl $argv;
end
