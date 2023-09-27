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
the release has a *label* in the changelog.
Please see [clq](https://github.com/denisa/clq/blob/main/README.md) for more details.

### `status`

The status of the release, one of `prereleased`, `released`, `unreleased`, or `yanked`.

### `changes`

All the changes defined for that release. Intended to be used for GitHub’s *release description*.

## Example Usage

### Feature Branch

This build only needs to validate that the changelog is syntactically correct.
To that effect, add
```yaml
    - name: Validate the changelog
      uses: denisa/clq-action@v1
      with:
        mode: feature
```

### Pull-request

This build ensures that the changelog introduces a new release version.
Use as
```yaml
  validate-release:
    if: github.event_name == 'pull_request' || github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Extract tag from the changelog
      uses: denisa/clq-action@v1
      id: clq-extract
      with:
        mode: release
    - name: Validate the tag has not yet been used
      uses: denisa/semantic-tag-helper@v1
      with:
        mode: test
        tag: ${{ steps.clq-extract.outputs.tag }}
```

### Release Branch

This build extracts from the changelog all the information needed to cut a new release.
Use
```yaml
  release:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: [ validate-release ]
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: denisa/clq-action@v1
      id: clq-extract
    - name: Create the tag
      uses: denisa/semantic-tag-helper@v1
      with:
        mode: set
        tag: ${{ steps.clq-extract.outputs.tag }}
    - uses: ncipollo/release-action@v1
      with:
        tag: ${{ steps.clq-extract.outputs.tag }}
        prerelease: ${{ steps.clq-extract.outputs.status == 'prereleased' }}
        name: ${{ steps.clq-extract.outputs.name }}
        body: ${{ steps.clq-extract.outputs.changes }}
```
