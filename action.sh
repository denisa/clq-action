#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

clq() {
  volumes=("-v" "${changeLog}:/home/CHANGELOG.md:ro")
  if [ -n "${mode}" ]; then
    set -- "${mode}" "$@"
  fi
  if [ -n "${changeMap}" ]; then
    set -- "-changeMap" "/home/changemap.json" "$@"
    volumes+=("-v" "${changeMap}:/home/changemap.json:ro")
  fi

  docker run "${volumes[@]}" --rm "${DOCKER_PROXY}denisa/clq:1.8.19" "$@" /home/CHANGELOG.md
}

mode=$1
shift
case "${mode}" in
  release)
    mode="-release"
    ;;
  feature)
    mode=''
    ;;
  *)
    echo "::error ::Mode ${mode} undefined, must be one of (feature|release)"
    exit 1
    ;;
esac

changeLog=$(realpath "$1")
shift
if ! [ -r "${changeLog}" ]; then
  echo "::error ::changeLog ${changeLog} is not readable"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  changeMap=$(realpath "$1")
  shift
  if ! [ -r "${changeMap}" ]; then
    echo "::error ::changeMap ${changeMap} is not readable"
    exit 1
  fi
else
  changeMap=''
fi
release_version="$(clq -query 'releases[0].version')"
release_tag="v${release_version}"

release_name="$(clq -query 'releases[0].label')"
if [ -z "${release_name}" ]; then
  release_name="Release ${release_version}"
fi

release_status="$(clq -query 'releases[0].status')"

release_changes="$(clq -output md -query 'releases[0].changes[]/')"

EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
{
  echo "changes<<${EOF}"
  echo "${release_changes}"
  echo "${EOF}"
  echo "name=${release_name}"
  echo "status=${release_status}"
  echo "tag=${release_tag}"
  echo "version=${release_version}"
} >> "${GITHUB_OUTPUT}"
