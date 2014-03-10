function current_git_branch {
  echo `git rev-parse --abbrev-ref HEAD`
}

alias gc='git commit -m'
alias ga='git add'
alias gs='git status -sb'
alias glo='git log --oneline'
alias gl="git log --graph --pretty=\"format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset\""
alias gds='git diff --staged'
alias gd='git diff'
alias standup="clear; git log --since '1 day ago' --oneline --no-merges --pretty=format':%C(yellow)%h %C(white)%B' --author johngallagher"
alias gco='git checkout'
alias gpr='git pull --rebase'
alias grb='git rebase -i @{u}'

# Set git autocompletion and PS1 integration
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /usr/local/git/contrib/completion/git-prompt.sh ]; then
  . /usr/local/git/contrib/completion/git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=true

