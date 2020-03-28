#!/bin/sh
cl=${1}
if [ $cl -gt 85 ] ; then
    tmux set -g status-right "#[fg=colour236,bg=colour235]#[fg=colour12,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour235,bg=colour12] #(~/tmux/suhu)#[fg=colour236,bg=colour12] #[fg=colour12,bg=colour236] #(~/tmux/mem) #[fg=colour12,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour235,bg=colour12] #(~/tmux/./bat)#[fg=colour236,bg=colour12] #[fg=colour12,bg=colour236] %H:%M ⌚ #[fg=colour4,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour0,bg=colour4] #h  #[fg=#e5c07b]#[fg=#e06c75,bg=#e5c07b]"
else
    tmux set -g status-right ""
fi
