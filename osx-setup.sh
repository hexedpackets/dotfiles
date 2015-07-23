#!/usr/bin/env bash


# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update
# Install brew bundle and run it
brew tap Homebrew/bundle
brew bundle

# Ruby
rbenv install 2.2.2

# Python
pip install -r python/requirements.txt
