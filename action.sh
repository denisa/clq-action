#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

clq() {
  volumes=("-v" "$changeLog:/home/CHANGELOG.md:ro")
  if [ -n "$mode" ]; then
    set -- "$mode" "$@"
  fi
  if [ -n "$changeMap" ]; then
    set -- "-changeMap" "/home/changemap.json" "$@"
    volumes+=("-v" "$changeMap:/home/changemap.json:ro")
  fi

  set -x
  docker run "${volumes[@]}" --rm "${DOCKER_PROXY}denisa/clq:1.7.3" "$@" /home/CHANGELOG.md
  set +x
}

mode=$1
shift
case "$mode" in
  release)
    mode="-release"
    ;;
  feature)
    mode=''
    ;;
   *)
   echo "::error ::Mode $mode undefined, must be one of (feature|release)"
   exit 1
   ;;
esac

changeLog=$(realpath "$1")
shift
if ! [ -r "$changeLog" ]; then
  echo "::error ::changeLog $changeLog is not readable"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  changeMap=$(realpath "$1")
  shift
  if ! [ -r "$changeMap" ]; then
    echo "::error ::changeMap $changeMap is not readable"
    exit 1
  fi
else
  changeMap=''
fi
release_version="$(clq -query 'releases[0].version')"
release_tag="v${release_version}"

release_name="$(clq -query 'releases[0].label')"
if [ -z "$release_name" ]; then
   release_name="Release $release_version"
fi

release_status="$(clq -query 'releases[0].status')"

release_changes="$(clq -output md -query 'releases[0].changes[]/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/%0A/g')"

echo "::set-output name=changes::$release_changes"
echo "::set-output name=name::$release_name"
echo "::set-output name=status::$release_status"
echo "::set-output name=tag::$release_tag"
echo "::set-output name=version::$release_version"
