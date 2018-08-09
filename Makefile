# make all to link everything from $(HOME)/src/dotfiles into $(HOME)
# make target to link just specific targets
.PHONY: default
default:
	# No sensible default behavior.
	# Possible targets: all, bin, mpv, opt, tmux, vim.

.PHONY: all
all: bin mpv opt tmux vim fish

.PHONY: bin
bin: opt tmux
	ln -s $(HOME)/src/dotfiles/bin  $(HOME)/bin 

.PHONY: mpv
mpv:
	ln -s $(HOME)/src/dotfiles/mpv  $(HOME)/.config/mpv 

.PHONY: opt
opt:
	ln -s $(HOME)/src/dotfiles/opt  $(HOME)/opt 

.PHONY: tmux
tmux:
	ln -s $(HOME)/src/dotfiles/tmux  $(HOME)/.tmux 

.PHONY: vim
vim:
	ln -s $(HOME)/src/dotfiles/vim  $(HOME)/.vim 

.PHONY: fish
fish:
	ln -s $(HOME)/src/dotfiles/fish/functions  $(HOME)/.config/fish

