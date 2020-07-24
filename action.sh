#!/bin/sh -l
set -o errexit
set -o nounset
set -o pipefail

case "$1" in
  release)
    mode="-release"
    ;;
  feature)
    mode=""
    ;;
   *)
   echo "::error ::Mode $1 undefined, must be one of (feature|release)"
   exit 1
   ;;
esac
changelog="$2"

release_version=$(/usr/bin/clq $mode -query 'releases[0].version' $changelog)
release_tag="v${release_version}"

release_name="$(/usr/bin/clq $mode -query 'releases[0].label' $changelog)"
if [ -z "$release_name" ]; then
   release_name="Release $release_version"
fi

release_status=$(/usr/bin/clq $mode -query 'releases[0].status' $changelog)

release_changes="$(/usr/bin/clq $mode -output md -query 'releases[0].changes[]/' $changelog)"

echo "::set-output name=changes::${release_changes//$'\n'/'%0A'}"
echo "::set-output name=name::$release_name"
echo "::set-output name=status::$release_status"
echo "::set-output name=tag::$release_tag"
echo "::set-output name=version::$release_version"
