#!/usr/bin/env bash
# AI-generated launcher based on https://github.com/davatorium/rofi/blob/next/source/modes/drun.c logic

set -euo pipefail

cmd="$1"
shift
args=("$@")

# Directories like rofi scans
xdg_data_dirs=(
    "${XDG_DATA_HOME:-$HOME/.local/share}/applications"
)
IFS=':' read -ra sys_dirs <<< "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
for dir in "${sys_dirs[@]}"; do
    xdg_data_dirs+=("$dir/applications")
done

find_desktop_file() {
    for dir in "${xdg_data_dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        while IFS= read -r -d '' file; do
            # Skip hidden or non-application files early
            if grep -Eq '^(Hidden|NoDisplay)=true' "$file"; then
                continue
            fi
            if ! grep -Eq '^Type=Application' "$file"; then
                continue
            fi

            exec_line=$(grep -E '^Exec=' "$file" | head -n1 | cut -d= -f2- | sed -E 's/%.//g')
            # Extract first word of Exec
            exec_cmd=$(echo "$exec_line" | awk '{print $1}')
            if [[ "$(basename "$exec_cmd")" == "$cmd" ]]; then
                echo "$file"
                return 0
            fi
        done < <(find "$dir" -type f -name '*.desktop' -print0 2>/dev/null)
    done
    return 1
}

desktop_file=$(find_desktop_file || true)

if [[ -n "${desktop_file:-}" ]]; then
    terminal=$(grep -E '^Terminal=' "$desktop_file" | cut -d= -f2)
    if [[ "$terminal" == "true" ]]; then
        exec alacritty -e "$cmd" "${args[@]}"
    else
        exec "$cmd" "${args[@]}" &
    fi
else
    # Fallback if no desktop file found
    if command -v "$cmd" >/dev/null 2>&1; then
        exec "$cmd" "${args[@]}" &
    else
        exec alacritty -e "$cmd" "${args[@]}"
    fi
fi
