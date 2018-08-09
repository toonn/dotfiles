# Defined in /tmp/fish.WWocy9/xa.fish @ line 2
function xa
	set -q argv[1]; or set argv (xclip -selection clipboard -o);
	mpv --vid=no --ytdl-format=bestaudio/best $argv;
end
