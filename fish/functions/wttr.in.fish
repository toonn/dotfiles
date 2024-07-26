function wttr.in
  printf \
    '%s: %s \e[31m%s\e[0m(\e[94m%s\e[0m) UV:\e[103m%s\e[0m\n\e[94m%s\e[0m %s\n' \
    ( curl -s 'wttr.in/'"$argv"'?format=%l+%c+%f+%h+%u+%p+%w' \
    | string split --no-empty ' ' \
    )
end
