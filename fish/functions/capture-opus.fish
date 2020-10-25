# Defined in /var/folders/xm/n96l21b93xx1bm16cjr16gq40000gn/T//fish.roiUJ9/capture-opus.fish @ line 3
function capture-opus
	ffmpeg -f avfoundation -i ":Built-in Microphone" -c:a libopus -vbr on -b:a 64k -ac 1 "$argv "(date -u '+%Y-%m-%d')'.opus'
end
