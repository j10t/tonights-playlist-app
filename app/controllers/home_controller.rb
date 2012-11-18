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


    # Get today's canonical date
    canonical_date = "#{Time.now.month}/#{Time.now.day}/#{Time.now.year}"

    # stub yesterday until we have today
    canonical_date = "#{Time.now.month}/17/#{Time.now.year}"

    # Get all of today's events
    todays_events = Event.where(:date => canonical_date)

    @playlist = [];

    # For each of today's events...
    todays_events.each do |e|
      event = {};

      event['venue'] = e.venue;
      event['tracks'] = [];

      # build an event object and put it in the playlist
      e.tracks.each do |t|
        track = {};
        track['artist'] = t['artist'];
        track['song_title'] = t['name'];
        track['track_source'] = t['source'];
        track['track_source_id'] = t['sourceid'];
        puts track['track_source_id']
        event['tracks'] << track unless track['track_source_id'].blank? || track['song_title'].blank? || track['artist'].blank?
      end # for each track loop

      @playlist << event;
      puts @playlist.to_json
    end # for each event loop

  end

end

