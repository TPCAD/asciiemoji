# vim:et sts=2 sw=2 ft=zsh
#
# Original minimal theme for zsh written by subnixr:
# https://github.com/subnixr/minimal
#
# Requires the `prompt-pwd` and `git-info` zmodules to be included in the .zimrc file.

# Global settings
if (( ! ${+OK_COLOR} )) typeset -g OK_COLOR=green
if (( ! ${+ERR_COLOR} )) typeset -g ERR_COLOR=red
if (( ! ${+BGJOB_MODE} )) typeset -g BGJOB_MODE=4
if (( ! ${+USER_EMOJI_OK} )) typeset -g USER_EMOJI_OK="(/w\\"
if (( ! ${+USER_EMOJI_ERROR} )) typeset -g USER_EMOJI_ERROR="(o_O)"
if (( ! ${+INSERT_CHAR} )) typeset -g INSERT_CHAR=">"
if (( ! ${+NORMAL_CHAR} )) typeset -g NORMAL_CHAR="*"

# Components
_prompt_keymap() {
  case ${KEYMAP} in
    vicmd) print -n -- ${NORMAL_CHAR} ;;
    *) print -n -- ${INSERT_CHAR} ;;
  esac
}

_prompt_keymap-select() {
  zle reset-prompt
}
if autoload -Uz is-at-least && is-at-least 5.3; then
  autoload -Uz add-zle-hook-widget && \
      add-zle-hook-widget -Uz keymap-select _prompt_keymap-select
else
  zle -N zle-keymap-select _prompt_keymap-select
fi

# Setup
typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:prompt-pwd:tail' length 2
zstyle ':zim:prompt-pwd:separator' format '%f/%F{magenta}'

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format 'HEAD'
  zstyle ':zim:git-info:clean' format '%F{${OK_COLOR}}'
  zstyle ':zim:git-info:dirty' format '%F{${ERR_COLOR}}'
  zstyle ':zim:git-info:unindexed' format '!'
  zstyle ':zim:git-info:indexed' format '+'
  zstyle ':zim:git-info:keys' format \
      'status' '%I%i' \
      'rprompt' ' %C%D%b%c${(e)git_info[status]:+" %F{red}[${(e)git_info[status]}]"}'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

PS1=$'%F{cyan}${SSH_TTY:+"%m "}%f%F{yellow}${VIRTUAL_ENV:+"${VIRTUAL_ENV:t} "}%f%F{%(?.${OK_COLOR}.${ERR_COLOR})}%(?.${USER_EMOJI_OK}.${USER_EMOJI_ERROR})%f %B$(_prompt_keymap) %F{magenta}$(prompt-pwd)%b%f
%(!.#.$) '
RPS1='${(e)git_info[rprompt]}'
