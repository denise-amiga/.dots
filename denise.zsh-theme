### Run vcs_info selectively to increase speed in large repos ################

# The following example shows a possible setup for vcs_info which displays
# staged and unstaged changes in the vcs_info prompt and prevents running
# it too often for speed reasons.

# Allow substitutions and expansions in the prompt, necessary for
# using a single-quoted $vcs_info_msg_0_ in PS1, RPOMPT (as used here) and
# similar. Other ways of using the information are described above.
setopt promptsubst
# Load vcs_info to display information about version control repositories.
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
# Check the repository for changes so they can be used in %u/%c (see
# below). This comes with a speed penalty for bigger repositories.
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision false

# Alternatively, the following would set only %c, but is faster:
#zstyle ':vcs_info:*' check-for-changes false
#zstyle ':vcs_info:*' check-for-staged-changes true

zstyle ':vcs_info:*' stagedstr "%{$fg[green]%}✚ %{$reset_color%}"
zstyle ':vcs_info:*' unstagedstr "%{$fg[yellow]%}⚑ %{$reset_color%}"
zstyle ':vcs_info:*' formats " %{$fg[blue]%}[%{$fg[magenta]%}%b%{$fg[blue]%}] %u%c%{$reset_color%}"

# Default to running vcs_info. If possible we prevent running it later for
# speed reasons. If set to a non empty value vcs_info is run.
FORCE_RUN_VCS_INFO=1

# Only run vcs_info when necessary to speed up the prompt and make using
# check-for-changes bearable in bigger repositories. This setup was
# inspired by Bart Trojanowski
# (http://jukie.net/~bart/blog/pimping-out-zsh-prompt).
#
# This setup is by no means perfect. It can only detect changes done
# through the VCS's commands run by the current shell. If you use your
# editor to commit changes to the VCS or if you run them in another shell
# this setup won't detect them. To fix this just run "cd ." which causes
# vcs_info to run and update the information. If you use aliases to run
# the VCS commands update the case check below.
zstyle ':vcs_info:*+pre-get-data:*' hooks pre-get-data

+vi-pre-get-data() {
    # Only Git and Mercurial support and need caching. Abort if any other
    # VCS is used.
    [[ "$vcs" != git && "$vcs" != hg ]] && return

    # If the shell just started up or we changed directories (or for other
    # custom reasons) we must run vcs_info.
    if [[ -n $FORCE_RUN_VCS_INFO ]]; then
        FORCE_RUN_VCS_INFO=
        return
    fi

    # If we got to this point, running vcs_info was not forced, so now we
    # default to not running it and selectively choose when we want to run
    # it (ret=0 means run it, ret=1 means don't).
    ret=1
    # If a git/hg command was run then run vcs_info as the status might
    # need to be updated.
    case "$(fc -ln $(($HISTCMD-1)))" in
        git*)
            ret=0
            ;;
        hg*)
            ret=0
            ;;
    esac
}

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':  %c
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+="%{$fg[white]%}◒ %{$reset_color%}"
    fi
}

# Call vcs_info as precmd before every prompt.
prompt_precmd() {
    vcs_info
}
add-zsh-hook precmd prompt_precmd

# Must run vcs_info when changing directories.
prompt_chpwd() {
    FORCE_RUN_VCS_INFO=1
}
add-zsh-hook chpwd prompt_chpwd

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %{$fg_bold[yellow]%}%?) "

# Display the VCS information in the right prompt. The {..:- } is a
# workaround for Zsh below 4.3.9.
PROMPT='${ret_status}$fg[cyan]%~${vcs_info_msg_0_:- }$reset_color%#> '
