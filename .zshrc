# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Plugins
plugins=(git extract aliases z sudo tmux docker minikube docker-compose kubectl zsh-autosuggestions zsh-syntax-highlighting colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='nvim'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin
export TERM=screen-256color
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
source $HOME/.keychain/$HOST-sh

# git config.
alias dotfiles='/usr/bin/git --git-dir=/home/jasyuiop/.cfg/ --work-tree=/home/jasyuiop'

# nvim - vim
alias vim='nvim'

# tutor
alias tutor='vimtutor tr'
alias VimBeGood='vim -c "VimBeGood"'

# Tmux Sessions
alias mySession='tmux new-session -d -s "My Session"'

# Directory aliases
alias dvlp='cd ~/Developer'
alias mrkdwn='cd ~/Markdowns'
alias dwnl='cd ~/Downloads'
alias mydir='cd /mnt/c/Sync/MyDirectory'
alias nvimdir='cd ~/.config/nvim/'

# Useful aliases
alias df='df -h'
alias du='du -sh'
alias chmox='chmod +x'
alias diff='diff --color'
alias more='less'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
