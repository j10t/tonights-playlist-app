class HomeController < ApplicationController

  def index
    @playlist = [];       # The playlist for the UI

    #get todays time in utc
    @todays_datetime=Time.now.utc+Time.zone_offset('PST')

    if params[:month] && params[:day] && params[:year]
      # Use the given date
      params[:displayed_datetime] = DateTime.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    else
      # Use today's date
      params[:displayed_datetime] = @todays_datetime
    end

    # Get all of today's events
    todays_events = Event.where(:datetime => params[:displayed_datetime].beginning_of_day..params[:displayed_datetime].end_of_day)

    # For each of today's events...
    todays_events.each do |e|
      event = {};

      v = Venue.find(e.venue_id)
      event['venue'] = v.name;
      event['fulladdress'] = v.fulladdress;
      event['opentime'] = '';
      #convert military time to normal time and save in 'opentime' if we scraped an opening time
      event['opentime'] = "Doors open: "+Time.strptime(e.additionaldetails.split("Doors open: ")[1], "%H:%M").strftime("%l:%M%P") if e.additionaldetails.include?("Doors open: ");
      event['tracks'] = [];

      # build an event object and put it in the playlist
      e.artists.each do |a|
        a.tracks.each do |t|
          track = {};
          track['artist'] = a.name
          track['song_title'] = t.name
          track['track_source'] = t.source
          track['track_source_id'] = t.sourceid
          event['tracks'] << track unless track['track_source_id'].blank? || track['song_title'].blank? || track['artist'].blank?
        end
      end # for each track loop

     if !event['tracks'].blank? || params[:debug] == "true"
        @playlist << event;
     end
    end # for each event loop

    # randomize
    @playlist.shuffle!

  end

end

