setopt PROMPT_SUBST
autoload -Uz vcs_info add-zsh-hook

git_seg() {
  local ref="$vcs_info_msg_0_"
  [[ -z "$ref" ]] && return

  if test -n "$(git status --porcelain --ignore-submodules 2>/dev/null)"; then
    print -n "%B%F{#FFFF00} ${ref} ±%{%b%f%}%F{#FFFFFF}"
  else
    print -n " ${ref}"
  fi
}

git_precmd() {
  vcs_info
}
add-zsh-hook precmd git_precmd

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'

prompt='%K{#3584E4}%F{#FFFFFF}%}[%n@%m %1~/ $(git_seg)]%(#.#.$)%{%k%f%}%F{#3584E4}%{%f%} '

