MAKEFLAGS += --warn-undefined-variables --always-make
.DEFAULT_GOAL := _

DOCKER_PROGRESS?=auto
DOCKER_IMAGE=etriasnl/openresty
OPENRESTY_VERSION=0.2.1
PATCH_VERSION=$$(($(shell curl -sS "https://hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags/?page_size=1&page=1&name=${OPENRESTY_VERSION}-&ordering=last_updated" | jq -r '.results[0].name' | cut -f2 -d '-') + 1))

exec_docker=docker run $(shell [ "$$CI" = true ] && echo "-t" || echo "-it") -u "$(shell id -u):$(shell id -g)" --rm -v "$(shell pwd):/app" -w /app

lint-yaml:
	${exec_docker} cytopia/yamllint .
lint-dockerfile:
	${exec_docker} hadolint/hadolint hadolint Dockerfile
lint: lint-yaml lint-dockerfile
release:
	git tag "${OPENRESTY_VERSION}-${PATCH_VERSION}"
	git push --tags
build: lint
	docker buildx build --progress "${DOCKER_PROGRESS}" --tag "${DOCKER_IMAGE}:$(shell git describe --tags)" .
