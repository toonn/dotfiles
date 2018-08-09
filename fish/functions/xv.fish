# Defined in /tmp/fish.ljFxvZ/xv.fish @ line 2
function xv
	set -q argv[1]; or set argv (xclip -selection clipboard -o);
	mpv $argv
end
