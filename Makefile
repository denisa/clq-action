SHELL = /bin/bash

TARGET_TEST_FILE:=added-is-major added-is-minor

.PHONY: test
test: ${TARGET_TEST_FILE}

.PHONY: ${TARGET_TEST_FILE}
${TARGET_TEST_FILE}:%: shellcheck
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

.PHONY: versions
versions:
	diff --version
	docker --version
	grep --version

superlinter:
	docker run --rm \
		-e RUN_LOCAL=true \
		--env-file ".github/super-linter.env" \
		-w /tmp/lint -v "$$PWD":/tmp/lint \
		github/super-linter:v5
