help:
	cat Makefile

all: alpine

alpine:
	docker build -f Dockerfile.alpine -t "mantl_alpine" .

.PHONY: help all alpine ubuntu
