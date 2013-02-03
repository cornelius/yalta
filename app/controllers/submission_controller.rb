class SubmissionController < ApplicationController

  def new
  end
  
  def create
    @presentation = Presentation.new params[:presentation]

    @presentation.conference = current_conference

    if params[:author] =~ /(.*) <(.*)>/
      name = $1
      email = $2
    else
      name = params[:author]
    end

    logger.debug "AUTHOR: NAME #{name} EMAIL #{email}"

    author = Person.create! :name => name, :email => email,
      :bio => params[:bio], :conference => current_conference
    @presentation.people << author

    respond_to do |format|
      if @presentation.save
        flash[:notice] = 'Presentation was successfully created.'
        format.html { redirect_to(@presentation) }
        format.xml  { render :xml => @presentation, :status => :created, :location => @presentation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def export_text
    txt = ""
    Presentation.find_all_by_conference_id(current_conference).each do |p|
      txt += p.people.first.name + ": " + p.title
      if not p.tag_list.empty?
        txt += " [" + p.tag_list.join(",") + "]"
      end
      txt += "\n"
    end
    render :text => txt, :content_type => "text/plain"
  end

  def add_tags
    @presentation = Presentation.find params[:id]
  end

  def save_add_tags
    presentation = Presentation.find params[:id]
    presentation.tag_list.add params[:tags].split(TagList.delimiter)
    presentation.save!
    flash[:notice] = "Tags saved"
    redirect_to :controller => "presentations", :action => "show",
      :id => presentation.id
  end

  def remove_tags
    @presentation = Presentation.find params[:id]
  end

  def save_remove_tags
    presentation = Presentation.find params[:id]
    presentation.tag_list.remove params[:tags]
    presentation.save!
    flash[:notice] = "Tags removed"
    redirect_to :controller => "presentations", :action => "show",
      :id => presentation.id
  end

  def tag_cloud
    @tags = Presentation.tag_counts :conditions =>
      "conference_id = #{current_conference.id}"
  end

  def tag
    @tag = params[:id]
    @presentations = Presentation.find_tagged_with @tag, :order => "rating DESC"
    @presentations.reject! do |p|
      p.conference != current_conference
    end
  end

  def show_untagged
    @presentations = Presentation.find_all_by_conference_id current_conference
    @presentations.reject! do |p|
      !p.tag_list.empty?
    end
  end

  def assign_type
    @presentation = Presentation.find params[:id]
    @presentation_types = PresentationType.find :all
  end

  def assign_track
    @presentation = Presentation.find params[:id]
    @tracks = Track.find_all_by_conference_id current_conference
  end

  def save_assign_type
    presentation = Presentation.find params[:id]
    type = params[:type]

    presentation.presentation_type_id = type
    presentation.save!
    
    redirect_to :controller => "presentations", :action => "show",
      :id => presentation.id
  end

  def save_assign_track
    presentation = Presentation.find params[:id]
    track = params[:track]

    if track == 0
      presentation.track = nil
    else
      presentation.track_id = track
    end
    presentation.save!
    
    if !params[:go_back].blank?
      redirect_to params[:go_back]
    else
      redirect_to :controller => "presentations", :action => "show",
        :id => presentation.id
    end
  end

  def assign_slot
    @presentation = Presentation.find params[:id]
    @schedule = current_conference.schedule
    @slot_content = "assign_slot_content"
    @active_slot = @presentation.slot
    @show_availability = true
  end
  
  def save_assign_slot
    presentation = Presentation.find params[:id]
    if params[:slot] == "0"
      slot = nil
      other_presentation = nil
    else
      slot = Slot.find params[:slot]
      other_presentation = slot.presentation
    end
    
    if other_presentation
      if params[:swap]
        other_presentation.slot = presentation.slot
      else
        other_presentation.slot = nil
      end
    end
    
    presentation.slot = slot

    Presentation.transaction do
      presentation.save!
      if other_presentation
        other_presentation.save!
      end
    end
    
    if !params[:go_back].blank?
      redirect_to params[:go_back]
    else
      redirect_to :controller => "presentations", :action => "show",
        :id => presentation.id
    end
  end

end
