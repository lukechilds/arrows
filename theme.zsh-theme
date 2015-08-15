# Set default options
[ -z "$THEME_EXTRA_NEWLINE" ] && THEME_EXTRA_NEWLINE=1
[ -z "$THEME_CWD_LENGTH" ] && THEME_CWD_LENGTH=1

# Outputs prompt string
theme_build_prompt() {

  # Easy use of linebreaks
  newline=$'\n'

  # Start prompt on a new line
  if [ $THEME_EXTRA_NEWLINE == 1 ]; then
    echo -n "${newline}"
  fi

  # Current working directory
  echo -n "%F{magenta}%${THEME_CWD_LENGTH}~%f "

  # Prompt symbol
  echo -n "%F{blue}%#%f "

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
