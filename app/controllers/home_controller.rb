class HomeController < ApplicationController

  def index
    @playlist = [];      # The playlist for the UI

    # Get today's canonical date
    canonical_date = "#{Time.now.month}/#{Time.now.day}/#{Time.now.year}"

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
        puts track['track_source_id']
        event['tracks'] << track unless track['track_source_id'].blank? || track['song_title'].blank? || track['artist'].blank?
      end # for each track loop

      if !event['tracks'].blank?
        @playlist << event;
      end
    end # for each event loop

    # randomize
    @playlist.shuffle!

  end

end

