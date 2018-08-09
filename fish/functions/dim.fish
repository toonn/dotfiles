# Defined in /tmp/fish.4eP3yB/dim.fish @ line 2
function dim
	echo $argv >/sys/class/backlight/radeon_bl0/brightness
end
