class Admin::PresentationTypesController < Admin::BaseController
  # GET /admin/presentation_types
  # GET /admin/presentation_types.xml
  def index
    @presentation_types = PresentationType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @presentation_types }
    end
  end

  # GET /admin/presentation_types/1
  # GET /admin/presentation_types/1.xml
  def show
    @presentation_type = PresentationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @presentation_type }
    end
  end

  # GET /admin/presentation_types/new
  # GET /admin/presentation_types/new.xml
  def new
    @presentation_type = PresentationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presentation_type }
    end
  end

  # GET /admin/presentation_types/1/edit
  def edit
    @presentation_type = PresentationType.find(params[:id])
  end

  # POST /admin/presentation_types
  # POST /admin/presentation_types.xml
  def create
    @presentation_type = PresentationType.new(params[:presentation_type])

    respond_to do |format|
      if @presentation_type.save
        flash[:notice] = 'PresentationType was successfully created.'
        format.html { redirect_to [:admin, @presentation_type] }
        format.xml  { render :xml => @presentation_type, :status => :created, :location => @presentation_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presentation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/presentation_types/1
  # PUT /admin/presentation_types/1.xml
  def update
    @presentation_type = PresentationType.find(params[:id])

    respond_to do |format|
      if @presentation_type.update_attributes(params[:presentation_type])
        flash[:notice] = 'PresentationType was successfully updated.'
        format.html { redirect_to [:admin, @presentation_type] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presentation_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/presentation_types/1
  # DELETE /admin/presentation_types/1.xml
  def destroy
    @presentation_type = PresentationType.find(params[:id])
    @presentation_type.destroy

    respond_to do |format|
      format.html { redirect_to(admin_presentation_types_url) }
      format.xml  { head :ok }
    end
  end
end
