#!/usr/bin/env bash

sudo -v

echo "What would you to name your computer?"
read COMPUTER_NAME
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

echo "Using Google's DNS servers for Wi-Fi"
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

echo "Hide timemachine and user system icons"
# Get the system Hardware UUID and use it for the next menubar stuff
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
echo "Save to disk instead of icloud by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
echo "Disable display from automatically adjusting brightness"
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false
echo "Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
echo "Setting screenshot format to PNG"
defaults write com.apple.screencapture type -string "png"

echo "Disabling fucking emdashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "Show hidden files in Finder"
defaults write com.apple.Finder AppleShowAllFiles -bool true
echo "Show dotfiles in Finder"
defaults write com.apple.finder AppleShowAllFiles TRUE
echo "Show all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
echo "Set Dock to auto-hide"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

echo "Don't send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
echo "Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

mkdir ~/repos
mkdir ~/.vpn

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update
sudo -vn
# Install brew bundle and run it
brew tap Homebrew/bundle
brew tap homebrew/dupes
brew tap caskroom/cask
brew tap caskroom/versions
brew tap caskroom/fonts
brew tap homebrew/php/arcanist
brew bundle

# Enable accessiblity for dropbox
# NOTE: Doesn't work on sierra, there's an extra column needed
sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceAccessibility','com.getdropbox.dropbox',0,1,1,NULL);"

# Ruby
rbenv install 2.2.2
rbenv rehash
eval "$(rbenv init -)"
rbenv global 2.2.2
gem install bundler
rbenv rehash

# Python
pip install -r python/requirements.txt

# Elixir
mix do local.hex --force, local.rebar --force

echo "Disabling the backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "Killing some open applications in order to take effect."
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Safari" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

git clone https://github.com/monokal/Shellshock ~/repos/Shellshock
airodump-ng-oui-update

# Mail
sudo mkdir -p /etc/ssl/certs/
sudo chmod 755 /etc/ssl/
sudo chmod 755 /etc/ssl/certs/
sudo ln -s /usr/local/etc/openssl/cert.pem /etc/ssl/certs/ca-certificates.crt
pip install git+https://github.com/teythoon/afew.git
mkdir -p ~/.passwords/imap.gmail.com
