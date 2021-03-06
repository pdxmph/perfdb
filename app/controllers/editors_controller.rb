class EditorsController < ApplicationController
  # GET /editors
  # GET /editors.xml
  def index
    @editors = Editor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @editors }
    end
  end

  # GET /editors/1
  # GET /editors/1.xml
  def show
    @editor = Editor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @editor }
    end
  end

  # GET /editors/new
  # GET /editors/new.xml
  def new
    @editor = Editor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @editor }
    end
  end

  # GET /editors/1/edit
  def edit
    @editor = Editor.find(params[:id])
  end

  # POST /editors
  # POST /editors.xml
  def create
    @editor = Editor.new(params[:editor])

    respond_to do |format|
      if @editor.save
        format.html { redirect_to(@editor, :notice => 'Editor was successfully created.') }
        format.xml  { render :xml => @editor, :status => :created, :location => @editor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @editor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /editors/1
  # PUT /editors/1.xml
  def update
    @editor = Editor.find(params[:id])

    respond_to do |format|
      if @editor.update_attributes(params[:editor])
        format.html { redirect_to(@editor, :notice => 'Editor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @editor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /editors/1
  # DELETE /editors/1.xml
  def destroy
    @editor = Editor.find(params[:id])
    @editor.destroy

    respond_to do |format|
      format.html { redirect_to(editors_url) }
      format.xml  { head :ok }
    end
  end
end
