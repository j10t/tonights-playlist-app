class EventartistsController < ApplicationController
  def index
    @eventartists = Eventartist.all

    respond_to do |format|
      format.html
      format.json { render json: @eventartists }
    end
  end

  #TODO finish rest of actions
end
