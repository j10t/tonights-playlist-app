class HomeController < ApplicationController

  def index
    @playlist = [];       # The playlist for the UI
    canonical_date = ""   # Playlist date

    if params[:month] && params[:day] && params[:year]
      # Use the given date
      canonical_date = "#{params[:month]}/#{params[:day]}/#{params[:year]}"
    else
      # Use today's date
      canonical_date = "#{Time.now.month}/#{Time.now.day}/#{Time.now.year}"
    end

    # Get all of today's events
    todays_events = Event.where(:date => canonical_date)

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
        event['tracks'] << track unless track['track_source_id'].blank? || track['song_title'].blank? || track['artist'].blank?
      end # for each track loop

     if !event['tracks'].blank? || params[:debug] == "true"
        @playlist << event;
     end
    end # for each event loop

    # randomize
    @playlist.shuffle!

  end

end

