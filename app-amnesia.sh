#!/bin/bash -e

if [ "$UID" = "0" ] ; then
	echo "don't run this as root."
	exit 1
fi

DIR=$HOME/Library/Preferences/ByHost
UUID=`ioreg -d2 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $(NF-1)}'`
PLIST=$DIR/com.apple.loginwindow.$UUID.plist

enable_amnesia() {
	chflags nouchg $PLIST || true

	if [ ! -w "$PLIST" ] ; then
		echo "couldn't find or access the expected plist file: $PLIST"
		exit 1
	fi

	plutil -convert binary1 -o $PLIST - <<-EOF
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
		<plist version="1.0">
		<dict>
			<key>TALAppsToRelaunchAtLogin</key>
			<array/>
		</dict>
		</plist>
	EOF

	chflags uchg $PLIST

	echo "App Amnesia is enabled."
	exit 0
}

disable_amnesia() {
	chflags nouchg $PLIST
	echo "App Amnesia is disabled."
	exit 0
}

usage() {
	cat <<-EOF
		Usage: $0 [ enable | disable ]

		This tool enables or disables MacOS's ability to re-start open apps after a
		reboot. It works by writing an empty app list to the com.apple.loginwindow plist
		and locking the file.

		This only affects desktop apps, not Login Items, LaunchDaemons, etc.

		When disabling amnesia, the plist file is simply unlocked.

		The plist is located here:

		$PLIST

	EOF
	exit 1
}

case $1 in
enable)
	enable_amnesia
	;;
disable)
	disable_amnesia
	;;
*)
	usage
	;;
esac
