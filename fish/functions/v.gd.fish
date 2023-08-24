# Defined in /tmp/fish.koPwnF/v.gd.fish @ line 1
function v.gd
  curl -s "https://v.gd/create.php?format=simple&url=$argv"
  # shorturl= # If you want to request a specific string 5 to 30 chars, error if
  #           # taken
  # logstats=1 # If you want to track usage at https://v.gd/yoururl<dash>
end
