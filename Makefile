.PHONY: docker-test
docker-test: docker-build
	docker-compose -f Dockerfile.test.yml up

.PHONY: docker-build
docker-build: shellcheck
	docker build -f Dockerfile -t denisa/clq-action .

.PHONY: shellcheck
shellcheck:
	docker run --rm -v "$(CURDIR):/mnt" koalaman/shellcheck:v0.8.0 action.sh
