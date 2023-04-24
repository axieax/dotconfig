#!/bin/bash

QUERY_API="https://www.toptal.com/developers/gitignore/api"
GITIGNORE=".gitignore"
options=(${@// / })

if [[ -z "$options" ]]; then
  technologies="$(curl -sL ${QUERY_API}/list | tr "," "\n")"
  while true; do
    selected="$(echo "$technologies" | fzf)"
    if [[ $? = 0 ]]; then
      options+=("$selected")
    else
      break
    fi
  done
fi

# generate template
if [[ -n "$options" ]]; then
  query="$(echo "${options[@]}" | tr ' ' ',')"
  output="$(curl -sL "${QUERY_API}/$query")"
  echo -e "$output"
  read -p "Save to $GITIGNORE? [y/n] " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

  if [[ -f "$GITIGNORE" ]]; then
    echo "Adding to existing $GITIGNORE file"
    output="${output}\n\n$(cat $GITIGNORE)"
  fi
  echo -e "$output" > $GITIGNORE
  echo "$GITIGNORE successfully generated for $query"
fi
