# Defined in /tmp/fish.CoTqce/is.gd.fish @ line 1
function is.gd
  curl -s "https://is.gd/create.php?format=simple&url=$argv"
  # shorturl= # If you want to request a specific string 5 to 30 chars, error if
  #           # taken
  # logstats=1 # If you want to track usage at https://is.gd/yoururl<dash>
end
