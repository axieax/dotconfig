#!/bin/bash

QUERY_API="https://www.toptal.com/developers/gitignore/api"
GITIGNORE=".gitignore"
query=$@

if [[ ! -n $query ]]; then
  # select technologies if no query provided
  while true; do
    selected="$(curl -sL ${QUERY_API}/list | tr "," "\n" | fzf)"
    if [[ $? = 0 ]]; then
      # argument selected
      query="$query$selected,"
    else
      # strip last comma if exists
      query="$(echo $query | sed -e 's/\,$//')"
      break
    fi
  done
fi

# generate template
if [[ -n $query ]]; then
  output="$(curl -sL ${QUERY_API}/$query)"
  if [[ -f "$GITIGNORE" ]]; then
    # append existing gitignore contents
    output="${output}\n\n$(cat $GITIGNORE)"
  fi
  echo -e "$output" > $GITIGNORE
  echo "$GITIGNORE successfully generated for $query"
fi
