#!/bin/bash

#
# prerequisites

# activate all universe lines
success sed -i -e "'s%^# deb\(.*\) universe\$%deb\1 universe%g'" /etc/apt/sources.list
success apt-get update

success apt-get -y build-dep xbmc
success apt-get -y install shtool swig default-jre
