#!/usr/bin/env bash
cmd="$1"

desktop_file=$(grep -ril "Exec=$cmd" /usr/share/applications ~/.local/share/applications 2>/dev/null | head -n1)

if [[ -n "$desktop_file" ]]; then
    terminal=$(grep '^Terminal=' "$desktop_file" | cut -d= -f2)
    if [[ "$terminal" == "true" ]]; then
        exec alacritty -e $cmd
    else
        exec $cmd &
    fi
else
    # Fallback: assume CLI
    exec alacritty -e $cmd
fi
