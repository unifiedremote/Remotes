local script = libs.script;

--@help Mute mic
actions.toggleMute = function ()
	script.apple(
		"set lastActiveApp to (path to frontmost application as text)", -- save to switch back later
		"tell application \"Microsoft Teams\" to activate",
		"tell application \"System Events\" to tell process \"Microsoft Teams\"",
			"beep",
			"keystroke \"m\" using {command down, shift down}",
		"end tell",
		"tell application lastActiveApp to activate")
		actions.getIsMuted()
end

actions.getIsMuted = function ()
	out,err,res = script.apple(
		-- focus out of Teams and then back in to trigger refresh of Touch Bar content
		"set lastActiveApp to (path to frontmost application as text)",
		"if lastActiveApp is equal to (path to application \"Microsoft Teams\" as text) then",
			"tell application \"Finder\" to activate",
		"else",
			"tell application lastActiveApp to activate",
		"end if",
		"delay 1",
		"tell application \"Microsoft Teams\" to activate",
		-- read current mute state from description of Touch Bar mute/unmute button
		"tell application \"System Events\" to tell process \"Microsoft Teams\"",
			"if not (exists (first UI element whose role is \"AXFunctionRowTopLevelElement\")) then",
				"set out to \"Mute state unknown (Touch Bar unavailable)\"",
			"else",
				"tell (first UI element whose role is \"AXFunctionRowTopLevelElement\")",
					"if exists (first button whose description starts with \"Unmute\") then",
						"set out to \"Muted\"",
					"else if exists (first button whose description starts with \"Mute\") then",
						"set out to \"Unmuted\"",
					"else",
						"set out to \"Mute state unknown (not in call?)\"",
					"end if",
				"end tell",
			"end if",
		"end tell",
		"tell application lastActiveApp to activate",
		"get out")
	layout.isMuted.text = out

	if out == "Unmuted" then
		layout.isMuted.color = "orange"
	else
		layout.isMuted.color = "normal"
	end
end

--@help Accept audio call
actions.acceptAudioCall = function ()
	script.apple(
		"set lastActiveApp to (path to frontmost application as text)", -- save to switch back later
		"tell application \"Microsoft Teams\" to activate",
		"tell application \"System Events\" to tell process \"Microsoft Teams\"",
			"beep",
			"keystroke \"s\" using {command down, shift down}",
		"end tell",
		"tell application lastActiveApp to activate")
end

--@help Decline call
actions.declineCall = function ()
	script.apple(
		"set lastActiveApp to (path to frontmost application as text)", -- save to switch back later
		"tell application \"Microsoft Teams\" to activate",
		"tell application \"System Events\" to tell process \"Microsoft Teams\"",
			"beep",
			"keystroke \"d\" using {command down, shift down}",
		"end tell",
		"tell application lastActiveApp to activate")
end

--@help Accept audio call
actions.leaveCall = function ()
	script.apple(
		"set lastActiveApp to (path to frontmost application as text)", -- save to switch back later
		"tell application \"Microsoft Teams\" to activate",
		"tell application \"System Events\" to tell process \"Microsoft Teams\"",
			"beep",
			"keystroke \"b\" using {command down, shift down}",
		"end tell",
		"tell application lastActiveApp to activate")
end
