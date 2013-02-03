class PicturesController < ApplicationController

  def new
    @picture = Picture.new
    @person_id = params[:person_id]
  end

  def create
    @picture = Picture.new(params[:picture])
    @person_id = params[:person_id]
    person = Person.find @person_id
    person.picture = @picture
    if @picture.save
      flash[:notice] = 'Picture was successfully uploaded.'
      redirect_to :controller => "people", :action => "show", :id => @person_id
    else
      render :action => :new
    end
  end

  def show
    @picture = Picture.find params[:id]
  end

  def full
    picture = Picture.find params[:id]
    render :text => picture.current_data, :content_type => picture.content_type
  end

  def thumb
    thumbnail = Picture.find_by_parent_id_and_thumbnail params[:id], "thumb"
    render :text => thumbnail.current_data,
      :content_type => thumbnail.content_type
  end

  def mini
    mini = Picture.find_by_parent_id_and_thumbnail params[:id], "mini"
    render :text => mini.current_data,
      :content_type => mini.content_type
  end

end
