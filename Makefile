.PHONY: added-is-major
added-is-major: docker-build
	mkdir -p build
	rm -f build/added-is-major
	docker run --rm \
		-v "$(CURDIR)/test/changelog/added-is-major.md:/home/CHANGELOG.md:ro" \
		denisa/clq-action feature /home/CHANGELOG.md \
		> build/added-is-major
	diff -U3 test/expected/added-is-major build/added-is-major

.PHONY: added-is-minor
added-is-minor: docker-build
	mkdir -p build
	rm -f build/added-is-minor
	docker run --rm \
		-v "$(CURDIR)/test/changelog/added-is-minor.md:/home/CHANGELOG.md:ro" \
		-v "$(CURDIR)/test/changemap/added-is-minor.json:/home/changemap.json:ro" \
		denisa/clq-action feature /home/CHANGELOG.md /home/changemap.json \
		> build/added-is-minor
	diff -U3 test/expected/added-is-minor build/added-is-minor

.PHONY: docker-test
docker-test: added-is-major added-is-minor

.PHONY: docker-build
docker-build: shellcheck
	docker build -f Dockerfile -t denisa/clq-action .

.PHONY: shellcheck
shellcheck:
	docker run --rm -v "$(CURDIR):/mnt" koalaman/shellcheck:v0.9.0 action.sh
