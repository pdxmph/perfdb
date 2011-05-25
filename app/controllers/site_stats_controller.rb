class SiteStatsController < ApplicationController
  # GET /site_stats
  # GET /site_stats.xml
  def index
    @site_stats = SiteStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_stats }
    end
  end

  # GET /site_stats/1
  # GET /site_stats/1.xml
  def show
    @site_stat = SiteStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_stat }
    end
  end

  # GET /site_stats/new
  # GET /site_stats/new.xml
  def new
    @site_stat = SiteStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_stat }
    end
  end

  # GET /site_stats/1/edit
  def edit
    @site_stat = SiteStat.find(params[:id])
  end

  # POST /site_stats
  # POST /site_stats.xml
  def create
    @site_stat = SiteStat.new(params[:site_stat])

    respond_to do |format|
      if @site_stat.save
        format.html { redirect_to(@site_stat, :notice => 'Site stat was successfully created.') }
        format.xml  { render :xml => @site_stat, :status => :created, :location => @site_stat }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_stats/1
  # PUT /site_stats/1.xml
  def update
    @site_stat = SiteStat.find(params[:id])

    respond_to do |format|
      if @site_stat.update_attributes(params[:site_stat])
        format.html { redirect_to(@site_stat, :notice => 'Site stat was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_stats/1
  # DELETE /site_stats/1.xml
  def destroy
    @site_stat = SiteStat.find(params[:id])
    @site_stat.destroy

    respond_to do |format|
      format.html { redirect_to(site_stats_url) }
      format.xml  { head :ok }
    end
  end
end
