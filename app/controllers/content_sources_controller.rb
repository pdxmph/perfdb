class ContentSourcesController < ApplicationController
  # GET /content_sources
  # GET /content_sources.xml
  def index
     @content_sources = ContentSource.all(:conditions => ["code != ?", "A"])

      @cvc = GoogleChart::PieChart.new('350x200', "Total Views",  false)
      @ccc = GoogleChart::PieChart.new('350x200', "Total Spent",  false)


      @content_sources.each do |ct|
        @articles = Article.joins(:views).where("content_source != ? AND article_age = ?","A",30)
        @type_articles = @articles.where(["content_source = ?",ct.code])


        next if @type_articles.count == 0
        @cvc.data ct.name, @type_articles.sum('pageviews').to_i, "#{ct.color}"
        @ccc.data ct.name, @type_articles.sum('total_cost').to_f, "#{ct.color}"

      end
      @source_views_chart = @cvc.to_url
      @source_cost_chart = @ccc.to_url


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_sources }
    end
  end

  # GET /content_sources/1
  # GET /content_sources/1.xml
  def show
    @content_source = ContentSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content_source }
    end
  end

  # GET /content_sources/new
  # GET /content_sources/new.xml
  def new
    @content_source = ContentSource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content_source }
    end
  end

  # GET /content_sources/1/edit
  def edit
    @content_source = ContentSource.find(params[:id])
  end

  # POST /content_sources
  # POST /content_sources.xml
  def create
    @content_source = ContentSource.new(params[:content_source])

    respond_to do |format|
      if @content_source.save
        format.html { redirect_to(@content_source, :notice => 'Content source was successfully created.') }
        format.xml  { render :xml => @content_source, :status => :created, :location => @content_source }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /content_sources/1
  # PUT /content_sources/1.xml
  def update
    @content_source = ContentSource.find(params[:id])

    respond_to do |format|
      if @content_source.update_attributes(params[:content_source])
        format.html { redirect_to(@content_source, :notice => 'Content source was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /content_sources/1
  # DELETE /content_sources/1.xml
  def destroy
    @content_source = ContentSource.find(params[:id])
    @content_source.destroy

    respond_to do |format|
      format.html { redirect_to(content_sources_url) }
      format.xml  { head :ok }
    end
  end
end
