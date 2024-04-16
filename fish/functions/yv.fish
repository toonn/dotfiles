function yv
  set -q argv[1]; or set argv (clipboard);
  printf '%s' $argv
  if string match -rq 'youtu\.?be(\.com)?' -- $argv
    printf ' -> limit filesize <= 300M\n'
    mpv --ytdl-format='[filesize <=? 300M]' $argv
  else
    printf '\n'
    mpv --script-opts=ytdl_hook-ytdl_path=/home/toonn/.nix-profile/bin/yt-dlp $argv
  end
end
