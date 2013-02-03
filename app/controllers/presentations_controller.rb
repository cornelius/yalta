class PresentationsController < ApplicationController
  # GET /presentations
  # GET /presentations.xml
  def index
    @presentations = Presentation.find_all_by_conference_id(current_conference,
      :order => "rating DESC" )

    @presentations_map = Hash.new

    @presentations.each do |presentation|
      list = @presentations_map[presentation.presentation_type]
      if !list
        list = Array.new
      end
      list.push presentation
      @presentations_map[presentation.presentation_type] = list
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.xml
  def show
    @presentation = Presentation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.xml
  def new
    @presentation = Presentation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presentation }
    end
  end

  # GET /presentations/1/edit
  def edit
    @presentation = Presentation.find(params[:id])
  end

  # POST /presentations
  # POST /presentations.xml
  def create
    @presentation = Presentation.new(params[:presentation])
    @presentation.conference = current_conference

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

  # PUT /presentations/1
  # PUT /presentations/1.xml
  def update
    @presentation = Presentation.find(params[:id])

    respond_to do |format|
      if @presentation.update_attributes(params[:presentation])
        flash[:notice] = 'Presentation was successfully updated.'
        format.html { redirect_to(@presentation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.xml
  def destroy
    @presentation = Presentation.find(params[:id])
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to(presentations_url) }
      format.xml  { head :ok }
    end
  end


  def add_comment
    @comment = Comment.new
    @comment.text = params[:comment][:text]
    rating = params[:comment][:rating]
    if rating != "no rating"
      @comment.rated = true
      @comment.rating = rating
    end
    @comment.presentation_id = params[:id]
    @comment.user_id = current_user.id
    @comment.text.strip!

    @comment.presentation.rating += @comment.rating
    @comment.presentation.save!

    @comment.save!
        
    redirect_to :action => "show", :id => params[:id]
  end

  def delete_comment
    comment = Comment.find params[:comment_id]
    comment.presentation.rating -= comment.rating
    comment.presentation.save!
  
    Comment.delete params[:comment_id]
    
    redirect_to :action => "show", :id => params[:id]
  end

end
