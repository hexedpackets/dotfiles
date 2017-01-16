# dotfiles
Basic setup/configuration scripts, focused on OS X.

# Configuration
### tmux
Tmux is configured to put the next calendar event from google calendar in the right side of the status bar.
To configure this, put the full calendar name (me@gmail.com) in `~/.calendar`.

# Passwords

For email accounts:
```bash
 /usr/bin/security add-internet-password -a "bill.huba@gmail.com" -s "imap.gmail.com" -w [PASSWORD]
```
