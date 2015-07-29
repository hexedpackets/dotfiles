#!/usr/bin/env bash

# Intended to be run after authenticating to services such as Dropbox

# Restore applications
mackup restore

# Force configuration of gcal
gcalcli agenda
