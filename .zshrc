# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Repeat problem fixed
DISABLE_AUTO_TITLE="true"

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

# nvim
alias vim='nvim'

# Tmux Sessions
alias mux='tmux new-session -D -s "My Session"'

# Useful aliases
alias df='df -h'
alias du='du -sh'
alias chmox='chmod +x'
alias diff='diff --color'
alias more='less'

# Vmware aliases
alias mountShared='sudo /usr/bin/vmhgfs-fuse .host:/ /home/jasyuiop/shares -o subtype=vmhgfs-fuse,allow_other'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
