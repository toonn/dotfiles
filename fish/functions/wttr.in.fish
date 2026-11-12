function wttr.in
  printf \
    '%s: %s \e[31m%s\e[0m(\e[94m%s\e[0m) UV:\e[35m%s\e[0m
  \e[94m%s\e[0m \e[90m%s\e[0m\n' \
    ( curl -s 'wttr.in/'"$argv"'?format=%l+%c+%f+%h+%u+%p+%w' \
    | string split --no-empty ' ' \
    )
end
