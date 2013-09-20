# Inpired on mortalscumbag.zsh-theme
# Deeper instructions: https://wiki.archlinux.org/index.php/Zsh
function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[yellow]%}(ssh) "
  fi
}

local ret_status="%(?:%{$fg[green]%}:%{$fg[red]%})%?%{$reset_color%}"
PROMPT=$'\n$(ssh_connection)%(!.%{$fg_bold[red]%}.%{$fg_bold[cyan]%})%n@%m%{$reset_color%}%{$fg[yellow]%}: %~$(my_git_prompt)\n%f[${ret_status}] %# '

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_no_bold[white]%}‹ %{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_no_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_no_bold[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_no_bold[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_no_bold[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$fg_no_bold[white]%}›%{$reset_color%}"
