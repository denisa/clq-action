#!/usr/bin/env bash

[ "${RUNNER_DEBUG}" == 1 ] && set -xv

set -eu

clq() {
  volumes=("-v" "$1:/home/CHANGELOG.md:ro")
  shift
  if [ -n "${changeMap}" ]; then
    set -- "-changeMap" "/home/changemap.json" "$@"
    volumes+=("-v" "${changeMap}:/home/changemap.json:ro")
  fi

  docker run "${volumes[@]}" --rm "${DOCKER_PROXY}denisa/clq:1.8.28" "$@" /home/CHANGELOG.md
}

baseChangeLog=$(realpath "$1")
shift
if ! [ -r "${baseChangeLog}" ]; then
  echo "::warning::Base changeLog ${baseChangeLog} is not readable – skipping validation"
  exit 0
fi

changeLog=$(realpath "$1")
shift
if ! [ -r "${changeLog}" ]; then
  echo "::error::changeLog ${changeLog} is not readable"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  changeMap=$(realpath "$1")
  shift
  if ! [ -r "${changeMap}" ]; then
    echo "::error::changeMap ${changeMap} is not readable"
    exit 1
  fi
else
  changeMap=''
fi

base_version="$(clq "${baseChangeLog}" -query 'releases[0].version')"
previous_version="$(clq "${changeLog}" -query 'releases[1].version')"

if [ "${base_version}" != "${previous_version}" ]; then
  echo "::error::This pull-request introduces more than one new version, expected releases[1] to be ${base_version} but found ${previous_version}"
  exit 1
fi
