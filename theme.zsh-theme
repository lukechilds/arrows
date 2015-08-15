# Set default options
[ -z "$THEME_EXTRA_NEWLINE" ] && THEME_EXTRA_NEWLINE=1
[ -z "$THEME_CWD_LENGTH" ] && THEME_CWD_LENGTH=1

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
  echo -n "%F{magenta}%${THEME_CWD_LENGTH}~%f "

  # Prompt symbol
  [[ $root == 1 ]] && prompt_colour=red || prompt_colour=blue
  echo -n "%F{${prompt_colour}}%#%f "

  # Arrows
  arrows=(red yellow green)
  echo -n "${newline}"
  echo -n "%B"
  for colour in $arrows; do
    echo -n "%F{$colour}›%f"
  done
  echo -n "%b"

  # End with space
  echo -n " "

}

PROMPT=$(theme_build_prompt)
