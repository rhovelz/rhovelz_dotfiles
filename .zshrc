# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="dracula"
ZSH_THEME="robbyrussell"
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  sudo
  history
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
## LAZY GIT
#
function xv4nz7webgit() {
    git add .
    git commit -a -m "$1"
    git push origin main
}


function xv4nz7git() {
    git add .
    git commit -a -m "$1"
    git push
}

# reboot shutdown
alias ssn="sudo shutdown now"
alias sr="sudo reboot"

alias tmuxrh="tmux new -s 'R A D I V A N' weechat\;"
#alias tmuxrh="tmux new -s 'R A D I V A N' opencode\; split-window -h weechat \;"
#alias tmuxrh='tmux new -s "R A D I V A N" \; split-window -h \; split-window -v \;'

# Enable Ctrl+arrow key bindings for word jumping
#bindkey '^[[1;5C' forward-word     # Ctrl+right arrow
#bindkey '^[[1;5D' backward-word    # Ctrl+left arrow
bindkey -e
bindkey ";5C" forward-word
bindkey ";5D" backward-word
set -o emacs

# Opening file with vim
export VISUAL=vim;
export EDITOR=vim;
export PATH=$HOME/.config/rofi/scripts:$PATH


# Add Nexus CLI to PATH
export PATH="/home/rh0v3lz/.nexus/bin:$PATH"

alias tb="nc termbin.com 9999"

export DISABLE_AUTO_TITLE=true
alias 0x0="curl -F 'file=@-' https://0x0.st"

WORDCHARS=${WORDCHARS//[\/.]/}

export TIP=46.202.196.131
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias updateandclean="sudo apt update && sudo apt install -y lynis chkrootkit clamav && sudo apt upgrade -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean && sudo apt clean && sudo freshclam && sudo clamscan -r -i ~ && sudo chkrootkit && sudo lynis audit system"
alias xv4nz7update="sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y sudo apt autoclean && sudo apt clean && sudo apt autoremove && sudo apt remove && sudo apt autoremove --purge"

test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)

alias l='lsd -altrh'

# Increase History Size
HISTSIZE=10000000        # Commands to remember in memory (session)
SAVEHIST=10000000        # Commands to save to the history file
HISTFILE=~/.zsh_history # File where history is stored

# Better history options
setopt INC_APPEND_HISTORY  # Save commands to history file as soon as they are typed
setopt SHARE_HISTORY       # Share history across all open terminals
setopt HIST_IGNORE_DUPS    # Ignore consecutive duplicate commands
setopt hist_ignore_space   # Trick to not record hist



# Open in tmux popup if on tmux, otherwise use --height mode
#
alias fzfprev="fzf --style full \
    --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"
#export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse  --border top'
#

# opencode
export PATH=/home/xv4nz7/.opencode/bin:$PATH

# Golang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH="$HOME/go/bin:$PATH"

# Ubah cat to bat
alias cat='bat --style=auto'

export PATH="$HOME/.local/bin:$PATH"

# mkdir & cd
function mkcd {
  command mkdir $1 && cd $1
}

# venv
alias venvactivate='source ~/.config/.venv/bin/activate'

#Home Windows
alias home='/mnt/c/Users/THINKPAD'
#alias iocbssn="/mnt/d/Radivan's File/OneDrive/OneDrive - PT. Bank Aceh Syariah/RH/CSIRT TTIS/IOC FROM BSSN"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


#eval "$(oh-my-posh init zsh --config dracula)"
#eval "$(oh-my-posh init zsh --config capr4n)"

#POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true


# FZF Catppuccin
#export FZF_DEFAULT_OPTS=" \
#--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
#--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
#--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
#--color=selected-bg:#45475A \
#--color=border:#6C7086,label:#CDD6F4"
