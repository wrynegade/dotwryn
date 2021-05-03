# pane switch with vim-like controls
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

bind -n M-H resize-pane -L 2
bind -n M-J resize-pane -D 2
bind -n M-K resize-pane -U 2
bind -n M-L resize-pane -R 2

# alt tab for window shift
bind-key -n M-Tab next-window
bind-key -n M-BTab previous-window

# alt number for switch
bind-key -n M-1 select-window -t 0
bind-key -n M-2 select-window -t 1
bind-key -n M-3 select-window -t 2
bind-key -n M-4 select-window -t 3
bind-key -n M-5 select-window -t 4
bind-key -n M-6 select-window -t 5
bind-key -n M-7 select-window -t 6
bind-key -n M-8 select-window -t 7
bind-key -n M-9 select-window -t 8

# new window and split pane quickly
bind-key -n M-c new-window
bind-key -n M-Enter new-window
bind-key -n M-v split-window -v
bind-key -n M-b split-window -h
bind-key -n M-q killp
bind-key -n M-z resize-pane -Z

# nested session with meta-a
bind-key -n M-a send-prefix

# rena[M]e session
bind-key -n M-m command-prompt -I "#S" "rename-session '%%'"

# rename [w]indow
bind-key -n M-w command-prompt -I "#W" "rename-window '%%'"

# toggle readonly session
bind-key -n M-r switch-client -r;
