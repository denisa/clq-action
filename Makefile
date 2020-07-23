.PHONY: docker-test
docker-test: docker-build
	docker-compose -f Dockerfile.test.yml up

.PHONY: docker-build
docker-build:
	docker build -f Dockerfile -t denisa/clq-action .

