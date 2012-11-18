class TracksController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @tracks = @event.tracks.all
  end

  def show
    @event = Event.find(params[:event_id])
    @track = @event.tracks.find(params[:id])
  end

  def new
    @event = Event.find(params[:event_id])
    @track = @event.tracks.build
  end

  def edit
    @event = Event.find(params[:event_id])
    @track = @event.tracks.find(params[:id])
  end

  def create
    @event = Event.find(params[:event_id])
    @track = @event.tracks.build(params[:track])

    if @track.save
      redirect_to event_track_path(@event,@track, notice: 'Stock was successfully created.')
    else
      render action: "new" 
    end
  end

  def update
    @event = Event.find(params[:event_id])
    @track = @event.tracks.build(params[:track])

    if @track.update_attributes(params[:track])
      redirect_to event_track_path @event,@track, notice: 'Stock was successfully created.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to event_tracks_url(@event)
  end
end
