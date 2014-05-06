#!/bin/bash

#
# prerequisites

# activate all universe lines
success sed -i -e "'s%^# deb\(.*\) universe\$%deb\1 universe%g'" /etc/apt/sources.list
