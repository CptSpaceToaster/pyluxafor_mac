################################################################################
.PHONY: help
help:
	@printf "Quick reference for supported build targets."\\n
	@printf "  help                          Display this message."\\n
	@printf "  check-tools                   Check if this user has required build tools in its PATH."\\n
	@printf "  test                          Run some tests!"\\n
	@printf "  install                       Install pyluxafor_mac locally!"\\n
	@printf "  clean-all                     Clean everything!"\\n
	@printf "  %-30s" "clean-$(VENV)"
	@printf "Clean the virtual environment, and start anew."\\n

################################################################################
include config.mk

.PHONY: check-tools
check-tools: $(TOOL_DEPS)
check-%:
	@printf "%-15s" "$*"
	@command -v "$*" &> /dev/null; \
	if [[ $$? -eq 0 ]] ; then \
		printf $(GRN)"OK"$(NC)\\n; \
		exit 0; \
	else \
		printf $(RED)"Missing"$(NC)\\n; \
		exit 1; \
	fi

######### Virtual Environment #########
$(VENV) $(PYTHON):
	$(MAKE) check-tools
	test -d $(VENV) || python$(VERSION) -m venv --without-pip $(VENV)

######### Pip #########
$(PIP): $(PYTHON)
	wget $(PIP_URL) -O - | $(PYTHON)

$(TWINE): $(PYTHON) $(PIP)
	$(PIP) install twine

# This creates a dotfile for the requirements, indicating that they were installed
.$(REQUIREMENTS): $(PIP) $(REQUIREMENTS)
	test -s $(REQUIREMENTS) && $(PIP) install -Ur $(REQUIREMENTS) || :
	touch .$(REQUIREMENTS)

######### Tests #########
.PHONY: test
test: $(PYTHON) .$(REQUIREMENTS)
	$(PYTHON) -m unittest discover -s $(PACKAGE)
	$(PYTHON) setup.py check --strict --restructuredtext

######### Release #########
.PHONY: list-sources
list-sources:
	@printf "$(SOURCES)"\\n

.PHONY: dist
dist: dist/$(PACKAGE)-*.tar.gz
dist/$(PACKAGE)-*.tar.gz: $(PYTHON) .$(REQUIREMENTS) $(SOURCES) setup.py
	$(PYTHON) setup.py sdist

.PHONY: install
install: .install
.install: dist/$(PACKAGE)-*.tar.gz
	pip$(VERSION) install $^
	$(PYTHON) setup.py install
	touch .install

.PHONY: upload-test
upload-test: .upload-test
.upload-test: $(TWINE) dist/$(PACKAGE)-*.tar.gz
	$(TWINE) upload --repository-url https://test.pypi.org/legacy/ dist/*
	touch .upload-test

.PHONY: release
release: .release
.release: .upload-test $(TWINE) dist/$(PACKAGE)-*.tar.gz
	$(TWINE) upload dist/*
	touch .release

######### Cleaning supplies #########
.PHONY: clean
clean:
ifneq ("$(wildcard .dist)","")
	$(PYTHON) setup.py clean
endif
	rm -rf .dist
	rm -rf .install
	rm -rf .upload-test
	rm -rf .release
	rm -rf dist
	rm -rf build
	rm -rf *egg-info

.PHONY: clean-all
clean-all: clean clean-$(VENV) clean-hooks

.PHONY: clean-$(VENV)
clean-$(VENV):
	rm -rf $(VENV)
	rm -rf .$(REQUIREMENTS)

.PHONY: clean-hooks
clean-hooks:
	rm -rf $(GIT_HOOKS)
