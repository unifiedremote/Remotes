# Spotify
A basic remote control for Spotify. Advanced features such as playlists and search are only available in the Spotify Advanced remote (included in the full version).

## Features
* Current playing informatiopn
* Playback control (play, pause, stop)
* Next and previous track
* Volume (raise, lower, mute)

## Screenshots
<img src="ignore/screen.png" width="200" />

## Platforms
* Windows
* Mac OS X
* Linux

## Implementation
The remote has been designed to work on as many different systems as possible. However, there is no cross-platform way to control the Spotify application. Therefore there is a remote implementation for each OS (Windows, Mac, Linux).

**Windows**  
Spotify for Windows is lacking in remote control entry points. However, WM_APPCOMMAND messages are supported:

    win.send(hwnd, WM_APPCOMMAND, 0, cmd);
    
For some actions, key presses events are sent to the window instead.

**Mac**  
Spotify for Mac supports AppleScript:
    
    tell application \"Spotify\" to ...
    
**Linux**
Spotify for Linux supports dbus commands:

    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify ...
    
Furthermore it uses grep to parse meta information (such as artist, track, album).


## Support
Developed and maintained by **Unified Remote**  
https://www.unifiedremote.com/help
