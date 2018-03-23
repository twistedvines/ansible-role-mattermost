#!/bin/bash
project_dir="$(cd "${BASH_SOURCE[0]%*/*}" && pwd)"

parse_args() {
  while getopts 'b:o:e:v:' arg; do
    case "$arg" in
      b)
        builder="$OPTARG"
        ;;
      o)
        outputs="$OPTARG"
        ;;
      e)
        environment="$OPTARG"
        ;;
      v)
        extra_vars_file="$OPTARG"
        ;;
    esac
  done
}

set_defaults() {
  [ -z "$environment" ] && environment='development'
  [ -z "$extra_vars_file" ] && extra_vars_file="${project_dir}/vars/main.yml"
}

print_environment() {
  for var in builder outputs environment extra_vars_file; do
    echo "$var" is set to "${!var}"
  done
}

parse_args $@
set_defaults
print_environment

case "$builder" in
  packer)
    packer build \
      "-only=$outputs" \
      -force \
      -var "playbook_file=${project_dir}/site.yml" \
      -var "environment=$environment" \
      -var "extra_vars_file=$extra_vars_file" \
      "${project_dir}/build/packer/build.json"
    ;;
esac
