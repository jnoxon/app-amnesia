## App Amnesia

This tool enables or disables MacOS's ability to re-start open apps after a reboot. It works by writing an empty app list to the com.apple.loginwindow plist and locking the file.

This only affects desktop apps, not Login Items, LaunchDaemons, etc.

When disabling amnesia, the plist file is simply unlocked.

### Usage:

bash <(curl -s https://raw.githubusercontent.com/jnoxon/app-amnesia/master/app-amnesia.sh) [ enable | disable ]
