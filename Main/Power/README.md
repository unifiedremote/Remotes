# Power
Control system power, login, and Wake on LAN.

## Features
* Restart system
* Shutdown system
* Logoff current user
* Lock computer (Windows and Mac)
* Put system in sleep state
* Put system in hibernate state (Windows)
* Abort any pending restart or shutdown (Windows)
* Send Wake On LAN/WAN

## Screenshots
<img src="screen-win.png" width="200" />
<img src="screen-osx.png" width="200" />
<img src="screen-lx.png" width="200" />

## Using WOL and WOW
The Wake On LAN and Wake on WAN packets are sent directly from your device when the server is sleeping. Most systems require WOL and WOW support to be explicitly enabled. Check out these tutorials for help.

* [https://www.unifiedremote.com/tutorials/how-to-configure-wake-on-lan-on-windows](How To Configure Wake On LAN on Windows)
* [https://www.unifiedremote.com/tutorials/how-to-configure-wake-on-wan-on-windows](How To Configure Wake On WAN on Windows)

## Linux Compatibility
Typically controlling system power is privilaged on Linux/UNIX systems. Most desktop environments therefore offer other means for applications to trigger these actions. However, there is unfortunately no standard. The remote has been implemented to work with:

* Unity
* KDE
* GNOME
* LXDE

For KDE the remote uses ``qdbus`` to ``org.kde.ksmserver ...`` for restart and shutdown.

For other DE and other actions the remote uses ``dbus-send`` to ``org.freedesktop.UPower ...``

Support for other systems will have to be added as needed.


## Support
Developed and maintained by **Unified Remote**  
https://www.unifiedremote.com/help
