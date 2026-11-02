#!/usr/bin/env bash
# Open a Bash shell with the pushed config in a clean container: ./test.sh
set -euo pipefail

repo="${NVIM_REPO:-https://github.com/Ajpreet-S/nvim.git}"
docker_args=(--rm)
if [[ -t 0 && -t 1 ]]; then
    docker_args+=(-it)
fi

exec docker run "${docker_args[@]}" alpine:3.23 sh -ec '
    apk add --no-cache bash neovim git ca-certificates
    git clone "$1" /root/.config/nvim
    shift
    printf "%s\n" "alias vim=nvim" "alias vi=nvim" > /root/.bashrc
    cd /root/.config/nvim
    exec bash "$@"
' sh "$repo" "$@"
