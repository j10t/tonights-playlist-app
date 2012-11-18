/*

Javascript to manage a YouTube track.

Depends on:
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>

*/

function createYoutubeTrackController(trackIndex, trackData, tracklistController) {

	var playerId = "player" + trackIndex;

	var trackController = {

		trackIndex: trackIndex,
		trackData: trackData,
		tracklistController: tracklistController,
		player: null, // initialized later
		isPlaying: false,

		playerId: "player" + trackIndex,

		// Load the player with the appropriate track in it and paused at the start
		loadPlayer: function() {
			var params = { allowScriptAccess: "always" };
			var atts = { id: this.playerId };
			swfobject.embedSWF("http://www.youtube.com/apiplayer?enablejsapi=1&version=3&playerapiid=" + this.playerId, this.playerId, "320", "240", "8", null, null, params, atts);
		},

		loadVideo: function() {
			this.player.loadVideoById(this.trackData.track_source_id); // Seems to autoplay
			this.player.pauseVideo();
		},

		togglePlayPause: function() {
			if (this.isPlaying) {
				this.pause();
			} else {
				this.play();
			}
		},

		play: function() {
			this.player.playVideo();
			this.isPlaying = true;
			document.getElementById("track" + this.trackIndex + "PlayPauseToggleButtonLabel").innerHTML = "Pause";
		},

		pause: function() {
			this.player.pauseVideo();
			this.isPlaying = false;
			document.getElementById("track" + this.trackIndex + "PlayPauseToggleButtonLabel").innerHTML = "Play";
		},

		stopPlaying: function() {
			// Note: stop is a reserved word
			this.isPlaying = false;
			this.player.stopVideo();
			document.getElementById("track" + this.trackIndex + "PlayPauseToggleButtonLabel").innerHTML = "Play";
		},

		// Get the % completion of the track, from 0 to 1.
		getPercentComplete: function() {
			var percentComplete = 100 * this.player.getCurrentTime() / thsi.player.getDuration();
			return percentComplete;
		}

	};

	youtubeTrackControllerMap[playerId] = trackController;

	// Hook up a click handler for the play/pause toggle, but wire it up via the tracklist controller, 
	// to keep everything in sync
	var playPauseToggleButton = document.getElementById("track" + trackIndex + "PlayPauseToggleButton");
	playPauseToggleButton.onclick = function() {
		var tracklistController = trackController.tracklistController;
		if (trackController.isPlaying) {
			tracklistController.pause.call(tracklistController);
		} else {
			tracklistController.switchTrack.call(tracklistController, trackController.trackIndex);
		}
	}

	trackController.loadPlayer.call(trackController);
	
	return trackController;
};

var youtubeTrackControllerMap = {};

function onYouTubePlayerReady(playerId) {
	var player = document.getElementById(playerId);
	var trackController = youtubeTrackControllerMap[playerId];
	trackController.player = player;

	trackController.loadVideo.call(trackController);

	player.addEventListener("onStateChange", function(newState) {

		// Call up to the tracklist to report when the track is finished playing
		if (newState == 0) {
			var tracklistController = trackController.tracklistController;
			tracklistController.trackFinished.call(tracklistController);
		}

	});
};
