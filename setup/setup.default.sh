#!/bin/bash

build_export SETUP_LOCALES "en_US.UTF-8"
build_export SETUP_PACKAGES "\
	ntpdate ntp \
	libdri2-1 \
	vim \
	"