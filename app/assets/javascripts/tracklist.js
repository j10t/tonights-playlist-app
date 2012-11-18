/*
This function creates an object used to control the whole playlist.

Depends on:
<script type="text/javascript" src="/assets/youtubeTrack.js"></script>

	tracks: [
		{
			<trackData>
		},
		{
			<trackData>
		},
		...
	]

*/

function createTracklistController(tracks) {

	var tracklistController = {

		trackControllers: null,		// initialized below
		currentTrackIndex: null,	// initialized below

		currentTrack: function() {
			return this.trackControllers[this.currentTrackIndex];
		},

		togglePlayPause: function() {
			if (this.currentTrack().isPlaying) {
				this.pause();
			} else {
				this.play();
			}
		},

		play: function() {
			var track = this.currentTrack();
			track.play.call(track);
			addClass(document.getElementById("playPauseToggleButton"), "active");
		},

		pause: function() {
			var track = this.currentTrack();
			track.pause.call(track);
			removeClass(document.getElementById("playPauseToggleButton"), "active");
		},

		stopPlaying: function() {
			// Note: stop is a reserved word in Javascript
			var track = this.currentTrack();
			track.stopPlaying.call(track);
			removeClass(document.getElementById("playPauseToggleButton"), "active");
		},

		switchTrack: function(newTrackIndex) {
			this.stopPlaying();
			this.currentTrackIndex = newTrackIndex;
			this.updateCurrentTrackInfo();
			this.play();
		},

		nextTrack: function() {
			this.stopPlaying();
			this.currentTrackIndex = (this.currentTrackIndex + 1) % this.trackControllers.length;
			this.updateCurrentTrackInfo();
			this.play();
		},

		updateCurrentTrackInfo: function() {
			var track = this.currentTrack();
			document.getElementById("artistName").innerHTML = track.trackData.artist;
			document.getElementById("songTitle").innerHTML = track.trackData.song_title;
			document.getElementById("venueName").innerHTML = track.trackData.venue;
		},

		updateTrackProgress: function() {
			var track = this.currentTrack();
			var percentComplete = track.getPercentComplete.call(track);
			document.getElementById("progressBar").style.width = percentComplete + "%";
		},

		trackFinished: function() {
			// Each track controller calls this method when the track is finished
			this.nextTrack();
		}

	};

	// Create a track controller for each track data object
	// This allows us to call play/pause/etc on each track
	// Each track controller keeps a reference to the tracklistController (this) 
	// so it can percolate up events (e.g. "my play button was clicked")
	var trackControllers = [];
	for (var i = 0; i < tracks.length; i++) {
		var trackData = tracks[i];

		var trackController = null;
		if (trackData.track_source == "Youtube") {
			trackController = createYoutubeTrackController(i, trackData, tracklistController);
		} else {
			console.log("No support for track_source " + trackData.track_source);
		}

		trackControllers[i] = trackController;
	}
	tracklistController.trackControllers = trackControllers;
	tracklistController.currentTrackIndex = 0;
	tracklistController.updateCurrentTrackInfo.call(tracklistController);

	// Hook up the main play/pause toggle button
	var playPauseToggleButton = document.getElementById("playPauseToggleButton");
	playPauseToggleButton.onclick = function() {
		tracklistController.togglePlayPause.call(tracklistController);
	}

	// Hook up the next-track button
	var nextTrackButton = document.getElementById("nextTrackButton");
	nextTrackButton.onclick = function() {
		tracklistController.nextTrack.call(tracklistController);
	}

	// Set up a timer to display the status of the current track
	setInterval(
		function() {
			tracklistController.updateTrackProgress.call(tracklistController);
		},
		200
	);

	return tracklistController;
};

