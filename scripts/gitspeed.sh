#!/bin/bash

# REF: https://github.com/starship/starship/issues/4305#issuecomment-1509498359
cd "$1"
git config core.fsmonitor true
git config feature.manyFiles true
git config core.untrackedCache true
# scalar register "$1"
