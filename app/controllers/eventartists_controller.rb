class EventartistsController < ApplicationController
  def index
    @eventartists = Eventartist.all

    respond_to do |format|
      format.html
      format.json { render json: @eventartists }
    end
  end

  def show
    @eventartist = Eventartist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eventartist }
    end
  end

  def new
    @eventartist = Eventartist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eventartist }
    end
  end

  def edit
    @eventartist = Eventartist.find(params[:id])
  end

  def create
    @eventartist = Eventartist.new(params[:eventartist])

    respond_to do |format|
      if @eventartist.save
        format.html { redirect_to @eventartist, notice: 'Eventartist was successfully created.' }
        format.json { render json: @eventartist, status: :created, location: @eventartist }
      else
        format.html { render action: "new" }
        format.json { render json: @eventartist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @eventartist = Eventartist.find(params[:id])

    respond_to do |format|
      if @eventartist.update_attributes(params[:eventartist])
        format.html { redirect_to @eventartist, notice: 'Eventartist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eventartist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @eventartist = Eventartist.find(params[:id])
    @eventartist.destroy

    respond_to do |format|
      format.html { redirect_to eventartists_url }
      format.json { head :no_content }
    end
  end
end
