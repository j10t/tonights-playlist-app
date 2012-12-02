class HomeController < ApplicationController

  def index
    @playlist = [];       # The playlist for the UI

    @todays_time = Time.now.in_time_zone("Pacific Time (US & Canada)")
    params[:todays_date] = @todays_time.strftime("%m/%d/%Y")
    params[:tomorrows_date] = (@todays_time+1.days).strftime("%m/%d/%Y")
    

    if params[:month] && params[:day] && params[:year]
      # Use the given date
      params[:displayed_date] = "#{params[:month]}/#{params[:day]}/#{params[:year]}"
    else
      # Use today's date
      params[:displayed_date] = params[:todays_date]
    end

    # Get all of today's events
    todays_events = Event.where(:date => params[:displayed_date])

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

