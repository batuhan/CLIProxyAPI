#!/bin/sh
set -eu
umask 077

data_dir="${CLIPROXY_DATA_DIR:-/data}"
mkdir -p "$data_dir/auths"

if [ ! -f "$data_dir/config.yaml" ]; then
  : "${CLIPROXY_CONFIG_B64:?Set CLIPROXY_CONFIG_B64 to initialize the persistent configuration}"
  printf '%s' "$CLIPROXY_CONFIG_B64" | base64 -d > "$data_dir/config.yaml.tmp"
  mv "$data_dir/config.yaml.tmp" "$data_dir/config.yaml"
fi

if [ ! -f "$data_dir/.accounts-imported" ] && [ -n "${CLIPROXY_AUTHS_B64:-}" ]; then
  printf '%s' "$CLIPROXY_AUTHS_B64" | base64 -d | tar -xz -C "$data_dir/auths"
  find "$data_dir/auths" -type f -exec chmod 600 {} +
  touch "$data_dir/.accounts-imported"
fi

unset CLIPROXY_CONFIG_B64 CLIPROXY_AUTHS_B64
exec "$@" --config "$data_dir/config.yaml"
