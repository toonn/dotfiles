# Defined in /tmp/fish.ydXvrj/ytdl.fish @ line 2
function ytdl
	set -q argv[1]; or set argv (xclip -selection clipboard -o);
	echo $argv; youtube-dl $argv;
end
