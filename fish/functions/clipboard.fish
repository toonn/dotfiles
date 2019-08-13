function clipboard
  set -l contents

  switch (uname -s)
  case Darwin
    set contents (pbpaste)
  case Linux
    set contents (xclip -selection clipboard -o)
  case '*'
    printf "%s\n" "Can't access clipboard!" 1>&2
  end

  printf "%s\n" "$contents"
end
