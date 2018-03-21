#!/bin/bash
builder="$1"
outputs="$2"
environment="${3:-development}"

project_dir="$(cd "${BASH_SOURCE[0]%*/*}" && pwd)"

case "$builder" in
  packer)
    packer build \
      "-only=$outputs" \
      -force \
      -var "playbook_file=${project_dir}/site.yml" \
      -var "environment=$environment" \
      "${project_dir}/build/packer/build.json"
    ;;
esac
