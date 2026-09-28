TF ?= terraform
DIRS := $(shell find modules stacks -name '*.tf' -not -path '*/.terraform/*' -exec dirname {} \; | sort -u)

.PHONY: fmt validate graph

fmt:
	$(TF) fmt -recursive

validate:
	@set -e; for dir in $(DIRS); do \
		echo "==> $$dir"; \
		$(TF) -chdir=$$dir init -backend=false -input=false -no-color >/dev/null; \
		$(TF) -chdir=$$dir validate -no-color; \
	done

graph:
	@if command -v stackorder >/dev/null 2>&1; then \
		stackorder graph --format dot; \
	else \
		echo "stackorder is not on PATH; install it from https://github.com/stackorder/stackorder/releases"; \
	fi
