## Created by newuser for 5.7.1

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

## load antigen
source "${HOME}/.antigen/antigen.zsh"
antigen init "${HOME}/.antigenrc"

## load enhancd
source "${HOME}/.enhancd/init.sh"

## enable autocompletion on /c /d /e
zstyle ':completion:*' fake-files /: '/:c d e'
zstyle ':completion:*' menu yes select

## set my paths
TMPDIR=/c/Users/Denise/.platformio/penv/Scripts
[ -d $TMPDIR ] && PATH=$PATH:$TMPDIR
TMPDIR=/c/Users/Denise/.local/bin
[ -d $TMPDIR ] && PATH=$PATH:$TMPDIR
unset TMPDIR

#BLITZMAX=/e/BmxNg
[ -d $BLITZMAX ] && export BLITZMAX
[ -d $BLITZMAX ] && PATH=$PATH:$BLITZMAX/bin

#PATH=$PATH:/e/freebasic

[ -e ~/.alias_user ] && source ~/.alias_user

#setgcc

##config Colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"
