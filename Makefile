.PHONY: added-is-major
added-is-major: shellcheck
	mkdir -p build
	rm -f build/added-is-major
	DOCKER_PROXY='' GITHUB_OUTPUT='build/added-is-major' ./action.sh feature \
		test/changelog/added-is-major.md
	diff -U3 test/expected/added-is-major build/added-is-major

.PHONY: added-is-minor
added-is-minor: shellcheck
	mkdir -p build
	rm -f build/added-is-minor
	DOCKER_PROXY='' GITHUB_OUTPUT='build/added-is-minor' ./action.sh feature \
		test/changelog/added-is-minor.md test/changemap/added-is-minor.json
	diff -U3 test/expected/added-is-minor build/added-is-minor

.PHONY: test
test: added-is-major added-is-minor

.PHONY: shellcheck
shellcheck:
	docker run --rm -v "$(CURDIR):/mnt" koalaman/shellcheck:v0.9.0 action.sh
