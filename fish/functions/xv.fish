# Defined in /var/folders/xm/n96l21b93xx1bm16cjr16gq40000gn/T//fish.j0iSTc/xv.fish @ line 2
function xv
  set -q argv[1]; or set argv (clipboard);
  printf '%s' $argv
  if string match -rq 'youtu\.?be(\.com)?' -- $argv
    printf ' -> limit resolution < 720p\n'
    mpv --ytdl-format='[height <? 720]' $argv
  else
    printf '\n'
    mpv $argv
  end
end
