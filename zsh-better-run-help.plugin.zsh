_man_page_exists() {
  local page="$1"
  man -w "$page" 1>/dev/null 2>/dev/null
}

better-run-help() {
  local args=( ${=BUFFER} )
  local command="${args[1]}"
  local subcommand="${args[2]}"

  if [[ "$command" == "" || "$command" == "man" || "$command" == "run-help" ]]
  then
    # Do nothing
    return
  fi

  if [[ "$subcommand" != "" ]] && _man_page_exists "${command}-${subcommand}"
  then
    LBUFFER="man ${command}-${subcommand}"
    zle accept-line
    zle -R -c
    return
  fi

  if _man_page_exists "$command"; then
    LBUFFER="man ${command}"
    zle accept-line
    zle -R -c
    return
  fi

  if [[ "${+commands[$command]}" == 1 ]]; then
    LBUFFER="${command}${subcommand:+ ${subcommand}} --help | \$PAGER"
  fi
}

zle -N better-run-help

bindkey "^[h" better-run-help
