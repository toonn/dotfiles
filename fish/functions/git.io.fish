# Defined in /tmp/fish.jssuUV/git.io.fish @ line 2
function git.io
  curl -si https://git.io -F "url=$argv" | rg 'Location: (.*)$' -r '$1'
  # -F "code=t"
end
