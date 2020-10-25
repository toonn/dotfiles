function fish_title
    # emacs is basically the only term that can't handle it.
    if not set -q INSIDE_EMACS
        if [ -z $argv ]
          set title fish
        else
          set title $argv
        end
        echo $title in (__fish_pwd)
    end
end
