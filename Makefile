#
# Makefile for more convenient building of the Linode CLI and its baked content
#

#PYTHON ?= 3
SPEC ?= https://developers.linode.com/api/docs/v4/openapi.yaml

#ifeq ($(PYTHON), 3)
#	PYCMD=python3
#	PIPCMD=pip3
#else
#	PYCMD=python
#	PIPCMD=pip
#endif

python_v_full := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
python_v_major := $(word 1,${python_v_full})


install: check-prerequisites requirements build
	ls dist/ | xargs -I{} pip install --force dist/{}

.PHONY: build
build: clean
	python -m linodecli bake ${SPEC} --skip-config
	cp data-$(python_v_major) linodecli/
	python setup.py bdist_wheel --universal

.PHONY: requirements
requirements:
	pip install -r requirements.txt

.PHONY: check-prerequisites
check-prerequisites:
	@ pip -v >/dev/null
	@ python -V >/dev/null

.PHONY: clean
clean:
	rm -f linodecli/data-*
	rm -f linode-cli.sh
	rm -f dist/*
