
.PHONY: code-vuln code-go-versions
code-vuln: ## Scan all Go modules and their standard library with the declared toolchain
	bash scripts/code-vuln.sh

code-go-versions: ## Check module, CI and Docker compiler versions
	python3 scripts/check-go-versions.py
