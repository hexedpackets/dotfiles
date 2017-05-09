# dotfiles
Basic setup/configuration scripts.

# Arch
The main package list is generated with `pacman -Qqetn > arch-pkglist.txt`. The AUR package list is generated with `pacman -Qetm > arch-aur.txt`.

The official packages can be restored with `sudo pacman -S - < arch-pkglist.txt`

# OSX
`osx-setup.sh` should be run first, followed by authentication with Dropbox and app-specific gmail passwords, and finally `osx-setup-post.sh` when the Dropbox sync is finished.

# Configuration
### tmux
Tmux is configured to put the next calendar event from google calendar in the right side of the status bar.
To configure this, put the full calendar name (me@gmail.com) in `~/.calendar`.

# Passwords

For email accounts:
```bash
 echo [PASSWORD] | gpg -e -r "William Huba" -a >  ~/.passwords/imap.gmail.com/[ADDRESS].gpg
```
