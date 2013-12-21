(function() {
	var update = {};
	
	update.title = document.getElementById("playerSongTitle").innerText;
	update.artist = document.getElementById("player-artist").innerText;
	update.album = document.getElementsByClassName("player-album")[0].innerText;
	update.position = document.getElementById("time_container_current").innerText;
	update.duration = document.getElementById("time_container_duration").innerText;
	
	update.playlists = [];
	var items = document.getElementById("playlists").getElementsByTagName("li");
	for (var i = 0; i < items.length; i++) {
		var item = items[i];
		var id = item.getAttribute("data-id");
		var title = document.evaluate("div[contains(@class,'tooltip')]", item, null, 9, null).singleNodeValue.textContent;
		update.playlists[i] = {};
		update.playlists[i].id = id;
		update.playlists[i].title = title;
	}
	
	update.tracks = []
	var songs = document.getElementsByClassName('song-row');
	for (var i = 0; i < songs.length; i++) {
		var song = songs[i];
		var id = song.getAttribute("data-id");
		var title = document.evaluate("td[@data-col='title']/span/text()", song, null, 9, null).singleNodeValue.textContent;
		var artist = document.evaluate("td[@data-col='artist']/span/text()", song, null, 9, null).singleNodeValue.textContent;
		update.tracks[i] = {};
		update.tracks[i].id = id;
		update.tracks[i].title = title;
		update.tracks[i].artist = artist;
	}
	
	return JSON.stringify(update);
})()