class TracksController < ApplicationController

  def index
    @tracks = Track.find_all_by_conference_id current_conference
  end
  
  def new
    @track = Track.new
  end

  def edit
    @track = Track.find params[:id]
  end
  
  def create
    @track = Track.new params[:track]
    @track.conference = current_conference
    if @track.save
      flash[:notice] = "Track #{@track.title} created."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @track = Track.find params[:id]
    if @track.update_attributes params[:track]
      flash[:notice] = "Track #{@track.title} updated"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @track = Track.find params[:id]
    @track.destroy
    
    redirect_to :action => "index"
  end

  def export
    @track = Track.find params[:id]
    @presentations = @track.presentations.sort do |a,b|
      b.rating <=> a.rating
    end
    if params[:slotted]
      @presentations.reject! do |p|
        !p.slot
      end
    end
    
    respond_to do |format|
      format.txt do
      end
    end
  end

end
