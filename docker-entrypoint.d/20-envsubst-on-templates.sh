#!/bin/sh

set -e

ME=$(basename $0)

auto_envsubst() {
  local template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR:-/opt/bitnami/openresty/nginx/conf/server_block_templates}"
  local suffix="${NGINX_ENVSUBST_TEMPLATE_SUFFIX:-.conf}"
  local output_dir="${NGINX_ENVSUBST_OUTPUT_DIR:-/opt/bitnami/openresty/nginx/conf/server_blocks}"

  local template defined_envs relative_path output_path subdir
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  [ -d "$template_dir" ] || return 0
  if [ ! -w "$output_dir" ]; then
    echo >&3 "$ME: ERROR: $template_dir exists, but $output_dir is not writable"
    return 0
  fi
  find "$template_dir" -follow -type f -name "*$suffix" -print | while read -r template; do
    relative_path="${template#$template_dir/}"
    output_path="$output_dir/${relative_path%$suffix}.conf"
    subdir=$(dirname "$relative_path")
    # create a subdirectory where the template file exists
    mkdir -p "$output_dir/$subdir"

    echo >&3 "$ME: Running envsub on $template to $output_path"
    envsub -g < "$template" > "$output_path"
  done
}

auto_envsubst

exit 0