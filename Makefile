.ONESHELL:
.PHONY: docs

SHELL:=bash

prepare: docs format validate

docs:
	terraform-docs markdown . --hide modules --output-file README.md
	git add README.md 2>/dev/null && git commit -m 'Update documentation.' || true

format:
	terraform fmt -diff -recursive
	git add -u 2>/dev/null && git commit -m 'Fix formatting.' || true

validate:
	terraform validate

# Direct assignment like TAG=$* would work but requires make version 4+
set_version.%:
	$(eval TAG := $*)
	git tag $(TAG)
	git push origin $(TAG)

# Direct assignment $(eval TAG=$$(git tag | sort -V | tail -n 1 | awk -F. -v OFS=. '{$$1=$$1+1; print}') would work but requires make version 4+
bump_version_major:
	$(eval TAG := $(shell git tag | grep -v '^v' | sort -V | tail -n 1 | awk -F. -v OFS=. '{$$1=$$1+1; print}'))
	git tag $(TAG)
	git push origin $(TAG)

bump_version_minor:
	$(eval TAG := $(shell git tag | grep -v '^v' | sort -V | tail -n 1 | awk -F. -v OFS=. '{$$2=$$2+1; print}'))
	git tag $(TAG)
	git push origin $(TAG)

bump_version_patch:
	$(eval TAG := $(shell git tag | grep -v '^v' | sort -V | tail -n 1 | awk -F. -v OFS=. '{$$3=$$3+1; print}'))
	git tag $(TAG)
	git push origin $(TAG)

bump_version: bump_version_patch
