#!/bin/ash -l
# shellcheck shell=dash

set -o errexit
set -o nounset
set -o pipefail

clq() {
  [ -n "$mode" ] && set -- "$mode" "$@"
  [ -n "$changeMap" ] && set -- "-changeMap" "$changeMap" "$@"
  /usr/bin/clq "$@"
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

changelog=$1
shift
if ! [ -r "$changelog" ]; then
  echo "::error ::changelog $changelog is not readable"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  changeMap="$1"
  shift
  if ! [ -r "$changeMap" ]; then
    echo "::error ::changeMap $changeMap is not readable"
    exit 1
  fi
else
  changeMap=''
fi
release_version="$(clq -query 'releases[0].version' "$changelog")"
release_tag="v${release_version}"

release_name="$(clq -query 'releases[0].label' "$changelog")"
if [ -z "$release_name" ]; then
   release_name="Release $release_version"
fi

release_status="$(clq -query 'releases[0].status' "$changelog")"

release_changes="$(clq -output md -query 'releases[0].changes[]/' "$changelog" | sed -e :a -e N -e '$!ba' -e 's/\n/%0A/g')"

echo "::set-output name=changes::$release_changes"
echo "::set-output name=name::$release_name"
echo "::set-output name=status::$release_status"
echo "::set-output name=tag::$release_tag"
echo "::set-output name=version::$release_version"
