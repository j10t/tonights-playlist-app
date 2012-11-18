class HomeController < ApplicationController

  def index
  	track1 = {artist: "Animal Collective", song_title: "My Girls", source: "youtube", source_id: "k213kjh"}
  	track2 = {artist: "Yeasayer", song_title: "Ampling Alp", source: "youtube", source_id: "8fsash"}
  	track3 = {artist: "Grimes", song_title: "Beast", source: "youtube", source_id: "dsf72s"}
  	event1 = {venue: "Neumos", tracks: {track1: track1, track2: track2, track3: track3}}
  	event2 = {venue: "Chop Suey", tracks: {track1: track3, track2: track1}}
  	@playlist = {event1: event1, event2: event2}
  end
end
