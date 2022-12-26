# clq-action
![GitHub Release Date](https://img.shields.io/github/release-date/denisa/clq-action?color=blue)
[![version](https://img.shields.io/github/v/release/denisa/clq-action?include_prereleases&sort=semver)](https://github.com/denisa/clq-action/releases)

GitHub action for the changelog query tool ([clq](https://github.com/denisa/clq))
— easily validate a changelog and extract the information needed to cut a release.



## Inputs

### `changelog`
The name of the changelog file. Default to `CHANGELOG.md`

### `changeMap`
Optional, the path to a file describing how to map change kind (Added, Changed, Fixed, ...)
to a version increment (`major`, `minor`, `patch`). The path is relative to the root of the
project.
See [clq documentation](https://github.com/denisa/clq#validation).

### `dockerProxy`
Optional, a prefix to the name of the `denisa/clq` docker image. This let docker access the
image through a proxy, which is handy to bypass dockerhub’s rate limiting.

Assuming for example a private instance of artifactory `artifactory.antonio.li`
[setup to proxy](https://jfrog.com/knowledge-base/how-to-configure-a-remote-repository-in-artifactory-to-proxy-a-private-docker-registry-in-docker-hub/)
docker images as a virtual `docker` repository, set `dockerProxy` to `artifactory.antonio.li/docker/`.

An alternative to that option would be to [configure the Docker daemon ](https://docs.docker.com/registry/recipes/mirror/#configure-the-docker-daemon) to use a mirror.

### `mode`
The validation mode, one of `feature` or `release`. Default to `release`.
The `feature` mode validates the syntax and the release ordering; the `release` mode
further enforces that the top-most entry has a release version.

## Outputs
All the outputs comes from the top-most entry in the changelog

### `version`
The release version.

### `tag`
The release version as a tag, that is the version prefixed with a `v`.

### `name`
The title of the release, it defaults to `Release` followed by the version, unless
the release has a _label_ in the changelog.
Please see [clq](https://github.com/denisa/clq/blob/main/README.md) for more details.

### `status`
The status of the release, one of `prereleased`, `released`, `unreleased`, or `yanked`.

### `changes`
All the changes defined for that release. Intended to be used for GitHub’s _release description_.

## Example Usage

### Feature Branch
This build only needs to validate that the changelog is syntactically correct.
To that effect, add
```yaml
    - name: Validate the changelog
      uses: denisa/clq-action@v1.1
      with:
        mode: feature
```

### Pull-request
This build must ensure that the changelog introduces a new release version.
Use as
```yaml
    - name: Extract tag from the changelog
      uses: denisa/clq-action@v1.1
      id: clq-extract
      with:
        mode: release
    - name: Validate the tag has not yet been used
      env:
        TAG: ${{ steps.clq-extract.outputs.tag }}
      run: |
        if git ls-remote --exit-code --tags origin "refs/tags/$TAG" >/dev/null 2>&1; then
          echo "::error ::tag $TAG exists already"
          exit 1
        fi
```

### Release Branch
This build must extract from the changelog all the information needed to cut a new release.
Use
```yaml
    - uses: actions/checkout@v3.0.2
    - uses: denisa/clq-action@v1.1
      id: clq-extract
    - name: Create tags
      env:
        tag_name: ${{ steps.clq-extract.outputs.tag }}
      run: |
        git config user.name github-actions
        git config user.email github-actions@github.com

        tags=()
        before_tag_name='v'
        until [ "$before_tag_name" = "$tag_name" ]; do
          tags+=("$tag_name")
          git tag "$tag_name"
          before_tag_name="$tag_name"
          tag_name="${tag_name%.*}"
        done
        git push origin "${tags[0]}"
        git push origin --force "${tags[@]:1}"
    - uses: ncipollo/release-action@v1.10.0
      with:
        tag: ${{ steps.clq-extract.outputs.tag }}
        prerelease: ${{ steps.clq-extract.outputs.status == 'prereleased' }}
        name: ${{ steps.clq-extract.outputs.name }}
        body: ${{ steps.clq-extract.outputs.changes }}

```
