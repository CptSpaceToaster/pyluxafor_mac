################################################################################
.PHONY: help
help:
	@printf "Quick reference for supported build targets."\\n
	@printf "  help                          Display this message."\\n
	@printf "  check-tools                   Check if this user has required build tools in its PATH."\\n
	@printf "  test                          Run some tests!"\\n
	@printf "  clean-all                     Clean everything!"\\n
	@printf "  %-30s" "clean-$(VENV)"
	@printf "Clean the virtual environment, and start anew."\\n
	@printf "  clean-hooks                   Clean and uninstall the git-hooks"\\n
	@printf "  clean-pycache                 Clean up python's compiled bytecode objects in the package"\\n

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

.PHONY: build
build: .build
.build: $(PYTHON) .$(REQUIREMENTS) $(SOURCES) setup.py
	$(PYTHON) setup.py build
	touch .build

.PHONY: install
install: .install
.install: .build
	$(PYTHON) setup.py install
	touch .install
	@printf "Installed locally in "$(GRN)$(VENV)"/bin/"$(NC)\\n

.PHONY: register
register: .register
.register: $(PYTHON) .$(REQUIREMENTS) $(SOURCES) setup.py
	$(PYTHON) setup.py register --strict
	touch .register

.PHONY: upload
upload: .upload
.upload: .build .register $(PYTHON) .$(REQUIREMENTS) $(SOURCES) setup.py
	$(PYTHON) setup.py sdist upload
	$(PYTHON) setup.py bdist_wheel upload
	touch .upload

######### Cleaning supplies #########
.PHONY: clean
clean:
ifneq ("$(wildcard .build)","")
	$(PYTHON) setup.py clean
endif
	rm -rf .build
	rm -rf .install
	rm -rf .upload

.PHONY: clean-all
clean-all: clean clean-$(VENV) clean-hooks clean-pycache

.PHONY: clean-$(VENV)
clean-$(VENV):
	rm -rf $(VENV)
	rm -rf .$(REQUIREMENTS)

.PHONY: clean-hooks
clean-hooks:
	rm -rf $(GIT_HOOKS)

.PHONY: clean-pycache
clean-pycache:
	find -path "*/__pycache__/*" -not -path "*/venv/*" -delete
	find -name "__pycache__" -not -path "*/venv/*" -type d -delete
