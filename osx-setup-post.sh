#!/usr/bin/env bash

# Intended to be run after authenticating to services such as Dropbox

# Restore applications
mackup restore

# Force configuration of gcal
gcalcli agenda

npm install -g diff-so-fancy

# Start syncing mail
echo "prime" | gpg -e -r "William Huba" --no-tty --batch > ~/.passwords/prime.gpg
brew services start offlineimap
