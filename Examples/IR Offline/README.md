# Custom IR (Offline)
How to use custom IR commands for offline use. This means that you can use the IR remote even if your computer is turned off as long as you are using a built-in IR blaster (or a network connected IR blaster).

## How it works
The offline version doesn't need a "remote.lua" file. Instead, the IR codes are specified in the "layout.xml" file.

Like this:

    <button text="Command 3" ontap="@irsend,0000 006F 0022 0002 0155 00AB 0016 0016 0016 0040 0016 0040 0016 0040 0016 0016 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0040 0016 0016 0016 0016 0016 0016 0016 0016 0016 0040 0016 0040 0016 0016 0016 0016 0016 0040 0016 0016 0016 0016 0016 0016 0016 0016 0016 0016 0016 0040 0016 0040 0016 0040 0016 0016 0016 0040 0016 0016 0016 0040 0016 0586 0155 0055 0016 0E36" />

## Getting help
Check out our tutorials: <br>
[https://www.unifiedremote.com/help](https://www.unifiedremote.com/help)
