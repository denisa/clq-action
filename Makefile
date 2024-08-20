SHELL = /bin/bash

TARGET_TEST_FILE:=added-is-major added-is-minor

.PHONY: test
test: ${TARGET_TEST_FILE} $(if $(findstring $(CI),true),,shellcheck)

.PHONY: ${TARGET_TEST_FILE}
${TARGET_TEST_FILE}:%:
	mkdir -p build
	rm -f build/$*
	DOCKER_PROXY='' GITHUB_OUTPUT='build/$*' ./action.sh feature \
		test/changelog/$*.md $(wildcard test/changemap/$*.json)
	diff -U3 \
		<( grep -vE '(changes<<)?[a-zA-Z0-9+/=]{20}' test/expected/$* ) \
		<( grep -vE '(changes<<)?[a-zA-Z0-9+/=]{20}' build/$* )

.PHONY: shellcheck
shellcheck:
	docker run --rm -v "$(CURDIR):/mnt" koalaman/shellcheck:v0.9.0 action.sh

superlinter:
	docker run --rm \
		--platform linux/amd64 \
		--rm \
		-e RUN_LOCAL=true \
		-e SHELL=/bin/bash \
		--env-file ".github/super-linter.env" \
		-w /tmp/lint -v "$$PWD":/tmp/lint \
		ghcr.io/super-linter/super-linter:v7

.PHONY: versions
versions:
	diff --version
	docker --version
	grep --version
