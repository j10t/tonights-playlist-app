class TracksController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @tracks = @event.tracks.all
    @venue = Venue.find(@event.venue_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end

  def show
    @event = Event.find(params[:event_id])
    @track = @event.tracks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  def new
    @event = Event.find(params[:event_id])
    @track = @event.tracks.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @track = @event.tracks.find(params[:id])
  end

  def create
    @event = Event.find(params[:event_id])
    @track = @event.tracks.build(params[:track])

    respond_to do |format|
      if @track.save
        format.html { redirect_to event_track_path(@event,@track, notice: 'Track was successfully created.') }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:event_id])
    @track = @event.tracks.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to event_track_path @event,@track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to event_tracks_url(@event) }
      format.json { head :no_content }
    end
  end
end
