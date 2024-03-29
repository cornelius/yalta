class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.find_all_by_conference_id current_conference,
      :order => "name"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])

    @person.conference = current_conference

    respond_to do |format|
      if @person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  def add_author
    @person = Person.new
    @presentation = Presentation.find params[:id]
    @people = Person.find_all_by_conference_id current_conference,
      :order => "name"
  end  

  def save_add_author
    @person = Person.new(params[:person])
    @presentation = Presentation.find params[:presentation]

    @person.conference = current_conference

    respond_to do |format|
      if @person.save
        @presentation.people << @person
        @presentation.save!
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to :controller => :presentations,
          :action => :show, :id => @presentation.id }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "add_author" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def save_add_existing_author
    @person = Person.find params[:person]
    @presentation = Presentation.find params[:presentation]

    @person.conference = current_conference

    @person.save!

    @presentation.people << @person

    @presentation.save!

    flash[:notice] = 'Person was successfully added.'

    redirect_to :controller => :presentations,
      :action => :show, :id => @presentation.id
  end
  
end
