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
brew bundle

# Enable accessiblity for shiftit
sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "INSERT INTO access VALUES('kTCCServiceAccessibility','org.shiftitapp.ShiftIt',0,1,1,NULL);"

# Ruby
rbenv install 2.2.2

# Python
pip install -r python/requirements.txt
# Force configuration of gcal
gcalcli agenda

# Restore applications
mackup restore

echo "Disabling the backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "Killing some open applications in order to take effect."
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Safari" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

boot2docker -m 3072 init
boot2docker ssh -t 'echo "DOCKER_TLS=no" | sudo tee /var/lib/boot2docker/profile'
boot2docker restart

# Reset sudo time
sudo -K
