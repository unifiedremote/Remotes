# Microsoft Teams Remote

Basic remote to control Microsoft Teams app on macOS.

Uses AppleScript to trigger appropriate keyboard shortcuts.

Detection of current microphone mute state is based on Touch Bar button description,
so if for Macs without it You'll have to come up with something else
(so far I didn't find any other way – no corresponding message in log when mute is toggled,
the window itself is not Cocoa so no access to its elements either).
Toggling works though.