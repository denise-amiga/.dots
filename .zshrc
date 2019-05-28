source ~/antigen.zsh
antigen init ~/.antigenrc

tmpdir=/c/Users/Denise/.platformio/penv/Scripts
[ -d $tmpdir ] && PATH=$PATH:$tmpdir
tmpdir=/c/Users/Denise/.local/bin
[ -d $tmpdir ] && PATH=$PATH:$tmpdir
unset tmpdir

#BLITZMAX=/e/BlitzMax
#[ -d $BLITZMAX ] && PATH=$PATH:$BLITZMAX/bin
#[ -d $BLITZMAX ] && export BLITZMAX

#PATH=$PATH:/e/freebasic

[ -e ~/.alias_user ] && source ~/.alias_user

setgcc

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'

