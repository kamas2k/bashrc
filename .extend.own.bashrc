#
# ~/.extend.own.bashrc
#

#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced

# exports
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=nvim

# Always enable colored `grep` output`
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# system aliases
alias l='ls -lh'
alias la='ls -la'

alias ll='ls --color -l'
alias ls='ls --color'
alias up='cd ..'
alias lcd='l cd'

# apache
alias apachevhost='sudo nvim /etc/httpd/conf/vhosts'
alias apacheconfig='sudo nvim /etc/httpd/conf/httpd.conf'
alias aprestart='sudo apachectl restart'

# php
alias phpini='sudo nvim /etc/php56/php.ini'

# chrome without web-security
alias chromedisweb='open -a Google\ Chrome --args --disable-web-security --user-data-dir'

# npm
alias npmg='npm list -g --depth 0'

# symfony
alias scc='./symfony doctrine:build-model; ./symfony doctrine:build-form; sass --force --style expanded --update .; ./symfony cc'
alias snew='./php symfony propel:build-model; ./php symfony project:permissions; ./symfony cc'
alias s='php symfony'

# Haskell
compileWithGHC() {
  ghc -o $2 $1
}
alias ch=compileWithGHC

# Git
alias gp='git pull --rebase'
alias gd='git diff'
alias gs='git status'
alias cleanclone="git push --delete my $(git branch -r --merged master | grep -v master | sed -n -E 's!^ +my/!!p')"
alias gls='git stash list'
diffStash() {
  git diff stash@{$1};
}
alias gds=diffStash
deleteStash() {
  git stash drop stash@{$1};
}
alias gdels=deleteStash
unStash() {
  git unstash stash@{$1};
}
alias gus=unStash
saveStash() {
  git stash save $1
}
alias gss=saveStash

tarExtract() {
  tar -zxvf $1
}
alias tarex=tarExtract

tarArchive() {
  tar -zcvf $1 $2
}
alias tarac=tarArchive

uP() {
  local x="";
  for i in $(seq ${1:-1})
  do
    x="$x../"
  done
  cd $x;
}

printDebug() {
  echo "\Doctrine\Common\Util\Debug::dump($test);" | xclip -selection clipboard;
}

[[ -f ~/.git-colorprompt.bash ]] && . ~/.git-colorprompt.bash
