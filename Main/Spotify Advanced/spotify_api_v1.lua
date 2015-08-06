local server = require("server");


function spotify_api_v1_log (str)
	print("spotify_api_v1.lua: " .. str);
end

function spotify_api_v1_url (path)
	-- spotify_api_v1_log("https://api.spotify.com/v1" .. path);
	return "https://api.spotify.com/v1" .. path;
end

function is_connected()
	return server.connect("spotify");
end

function ensure_connect()
	if (not is_connected()) then
		open_connect_dialog();
	end
end

function open_connect_dialog()
	server.update({ 
	    type = "dialog", 
	    text = "Connect your Spotify account to use Playlists and Search. Click 'Connect Spotify' in the server manager.", 
	    children = {
	    	{ type = "button", text = "Open...", ontap = "connect_dialog" },
	        { type = "button", text = "Cancel" }
	    }
	});
end

actions.connect_dialog = function(i)
	os.open("http://localhost:9510/web/#/status/connect");
end