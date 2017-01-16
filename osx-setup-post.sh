#!/usr/bin/env bash

# Intended to be run after authenticating to services such as Dropbox

# Restore applications
mackup restore

# Force configuration of gcal
gcalcli agenda

npm install -g diff-so-fancy

# Start syncing mail
brew services start offlineimap
