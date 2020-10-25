# Defined in /var/folders/xm/n96l21b93xx1bm16cjr16gq40000gn/T//fish.a2LpcP/multi_copy.fish @ line 1
function multi_copy
  # Could also do `head -n-0` but + makes it clearer it's not a flag
  tail -n+1 $argv
end
