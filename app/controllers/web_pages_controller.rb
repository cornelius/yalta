class WebPagesController < ApplicationController

  skip_before_filter :login_required
  before_filter :key_required, :except => "sorry_key"

  def program
    session[:key] = params[:key]
    @schedule = current_conference.schedule
    @slot_content = "show_slot_content"
    @page_title = "Akademy 2008 Conference Program"
  end

  def presentations
    @presentations = Presentation.find :all, :order => "title"
    @presentations.reject! { |p| !p.slot }
    @page_title = "Presentations"
  end
  
  def presentation
    @presentation = Presentation.find params[:id]
  end
  
  def speakers
    @people = Person.find :all, :order => "name"
    @people.reject! { |p| !p.slotted? }
    @page_title = "Speakers"
  end
  
  def photos
    picture = Picture.find params[:id]
    render :text => picture.current_data, :content_type => picture.content_type    
  end
  
  def sorry_key
  end
  
  private
  
  def key_required
    key = params[:key]
    if !key
      key = session[:key]
    end
    if key != current_conference.schedule.key
      redirect_to :action => :sorry_key
    end
  end
  
end
