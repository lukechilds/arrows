# Enable command substitution
setopt PROMPT_SUBST

# Set default options
[ -z "$THEME_EXTRA_NEWLINE" ] && THEME_EXTRA_NEWLINE=1
[ -z "$THEME_SHOW_CWD" ] && THEME_SHOW_CWD=1
[ -z "$THEME_CWD_LENGTH" ] && THEME_CWD_LENGTH=1
[ -z "$THEME_SHOW_PROMPT" ] && THEME_SHOW_PROMPT=1
[ -z "$THEME_SHOW_ARROWS" ] && THEME_SHOW_ARROWS=1
[ -z "$THEME_ARROW_COLOURS" ] && THEME_ARROW_COLOURS=(red yellow green)
[ -z "$THEME_ARROW_GIT_STATUS" ] && THEME_ARROW_GIT_STATUS=1

# Get git status
get_git_status() {

  # Set defaults
  git_unstaged=0
  git_staged=0

  # Cache status if we're in a repo
  if git_status=$(git status --porcelain 2>/dev/null); then
    in_git_repo=1
  else
    # If not stop everything
    in_git_repo=0
    return
  fi

  # Check for unstaged changes
  if echo $git_status | grep -q -e '^??' -e '^ M' -e '^ D'; then
    git_unstaged=1
  fi

  # Check for staged changes
  if echo $git_status | grep -q -e '^A' -e '^M' -e '^D' -e '^R'; then
    git_staged=1
  fi

}
precmd_functions=(get_git_status)

# Outputs prompt string
theme_build_prompt() {

  # Check if we're root
  [[ $(print -P "%#") == '#' ]] && root=1 || root=0

  # Easy use of linebreaks
  newline=$'\n'

  # Start prompt on a new line
  if [ $THEME_EXTRA_NEWLINE == 1 ]; then
    echo -n "${newline}"
  fi

  # Current working directory
  if [ $THEME_SHOW_CWD == 1 ]; then
    echo -n "%F{magenta}%${THEME_CWD_LENGTH}~%f "
  fi

  # Prompt symbol
  if [ $THEME_SHOW_PROMPT == 1 ]; then
    [[ $root == 1 ]] && prompt_colour=red || prompt_colour=blue
    echo -n "%F{${prompt_colour}}%#%f "
  fi

  # Arrows
  if [ $THEME_SHOW_ARROWS == 1 ]; then
    if [ $THEME_SHOW_CWD == 1 ] || [ $THEME_SHOW_PROMPT == 1 ]; then
      echo -n "${newline}"
    fi
    echo -n "%B"
    arrow=0
    for default_colour in $THEME_ARROW_COLOURS; do
      arrow=$((arrow + 1))
      arrowcolour=$default_colour
      if [ $in_git_repo == 1 ] && [ $THEME_ARROW_GIT_STATUS == 1 ]; then
        if [ $git_unstaged == 1 ] && [ $git_staged == 1 ]; then
          [[ $arrow == 1 ]] && arrowcolour=red
          [[ $arrow == 2 ]] && arrowcolour=red
          [[ $arrow == 3 ]] && arrowcolour=green
        elif [ $git_unstaged == 1 ]; then
          arrowcolour=red
        elif [ $git_staged == 1 ]; then
          arrowcolour=green
        fi
      fi
      echo -n "%F{$arrowcolour}›%f"
    done
    echo -n "%b "
  fi

}

# Rebuild prompt every time
PROMPT='$(theme_build_prompt)'
