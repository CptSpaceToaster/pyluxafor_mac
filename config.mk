################################################################################
# Package name
PACKAGE := pyluxafor_mac

ifneq ("$(shell which find)","")
    SOURCES := $(shell find ./$(PACKAGE)/*.py -type f -not -path "*/test/*")
else
    $(warning the find utility is not defined in the system path)
endif

REQUIREMENTS := requirements.txt

VENV := venv
VERSION := 3.7
PYTHON := $(VENV)/bin/python$(VERSION)
PIP := $(VENV)/bin/pip$(VERSION)
PIP_URL := https://bootstrap.pypa.io/get-pip.py

# Internal Script Configuration
TOOLS := bash python$(VERSION) wget find echo
TOOL_DEPS := $(addprefix check-,$(TOOLS))

ENABLE_COLOR := true
ifeq ($(ENABLE_COLOR),true)
    RED := "\e[0;31m"
    YLW := "\e[0;33m"
    GRN := "\e[0;32m"
    NC :=  "\e[0m"
endif