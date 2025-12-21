SHELL = /bin/bash
SUPER_LINTER_VERSION := $(shell grep -e '- uses: super-linter/super-linter@' .github/workflows/ci.yaml | cut -d'@' -f2)

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

.PHONY: super-linter
super-linter:
	docker run --rm \
		--pull always \
		--platform linux/amd64 \
		-e RUN_LOCAL=true \
		-e SHELL=/bin/bash \
		--env-file ".github/super-linter.env" \
		-w /tmp/lint -v $(CURDIR):/tmp/lint \
		ghcr.io/super-linter/super-linter:$(SUPER_LINTER_VERSION)

.PHONY: clq
clq:
	docker run --rm \
		--pull always \
		--volume $(CURDIR)/CHANGELOG.md:/home/CHANGELOG.md:ro \
		--volume $(CURDIR)/.github/clq/changemap.json:/home/changemap.json:ro \
		denisa/clq:1.8.23 -changeMap /home/changemap.json /home/CHANGELOG.md

.PHONY: shellcheck
shellcheck:
	docker run --rm \
		--volume "$(CURDIR):/mnt" \
		koalaman/shellcheck:v0.11.0 action.sh

.PHONY: lint
lint: clq super-linter

.PHONY: versions
versions:
	diff --version
	docker --version
	grep --version
