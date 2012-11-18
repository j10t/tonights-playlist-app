class HomeController < ApplicationController

  def index
  	track1 = {'artist' => "Animal Collective", 
  			  'song_title' => "My Girls", 
  			  'track_source' => "youtube", 
  			  'track_source_id' => "zol2MJf6XNE"}

  	track2 = {'artist' => "Yeasayer",
  			  'song_title' => "Ampling Alp",
  			  'track_source' => "youtube",
  			  'track_source_id' => "ZKXujEphWS8"}

  	track3 = {'artist' => "Grimes",
  			  'song_title' => "Beast Infection",
  			  'track_source' => "youtube",
  			  'track_source_id' => "EeT0XRSM6VQ"}

  	event1 = {'venue' => "Neumos",
  			  'tracks' => [track1, track2, track3]}
  	
  	event2 = {'venue' => "Chop Suey",
  			  'tracks' => [track1, track3]}

  	@playlist = [event1, event2]
  end

end
