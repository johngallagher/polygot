alias gc='git commit -m'
alias ga='git add'
alias gs='git status -sb'
alias glo='git log --oneline'
alias gl="git log --graph --pretty=\"format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset\""
alias gds='git diff --staged'
alias gd='git diff'
alias standup="clear; git log --since '1 day ago' --oneline --no-merges --pretty=format':%C(yellow)%h %C(white)%B' --author johngallagher"
alias gco='git checkout'

# Set git autocompletion and PS1 integration
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /usr/local/git/contrib/completion/git-prompt.sh ]; then
  . /usr/local/git/contrib/completion/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=true

# This messes up the prompt with oh my zsh
#PS1='\[\033[32m\]$(rvm current)\[\033[00m\]:\[\033[34m\]$(basename $PWD)\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
