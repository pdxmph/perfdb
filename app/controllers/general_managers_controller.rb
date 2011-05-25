class GeneralManagersController < ApplicationController
  # GET /general_managers
  # GET /general_managers.xml
  def index
    @general_managers = GeneralManager.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @general_managers }
    end
  end

  # GET /general_managers/1
  # GET /general_managers/1.xml
  def show
    @general_manager = GeneralManager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @general_manager }
    end
  end

  # GET /general_managers/new
  # GET /general_managers/new.xml
  def new
    @general_manager = GeneralManager.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @general_manager }
    end
  end

  # GET /general_managers/1/edit
  def edit
    @general_manager = GeneralManager.find(params[:id])
  end

  # POST /general_managers
  # POST /general_managers.xml
  def create
    @general_manager = GeneralManager.new(params[:general_manager])

    respond_to do |format|
      if @general_manager.save
        format.html { redirect_to(@general_manager, :notice => 'General manager was successfully created.') }
        format.xml  { render :xml => @general_manager, :status => :created, :location => @general_manager }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @general_manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /general_managers/1
  # PUT /general_managers/1.xml
  def update
    @general_manager = GeneralManager.find(params[:id])

    respond_to do |format|
      if @general_manager.update_attributes(params[:general_manager])
        format.html { redirect_to(@general_manager, :notice => 'General manager was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @general_manager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /general_managers/1
  # DELETE /general_managers/1.xml
  def destroy
    @general_manager = GeneralManager.find(params[:id])
    @general_manager.destroy

    respond_to do |format|
      format.html { redirect_to(general_managers_url) }
      format.xml  { head :ok }
    end
  end
end
