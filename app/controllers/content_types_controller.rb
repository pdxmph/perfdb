class ContentTypesController < ApplicationController
  # GET /content_types
  # GET /content_types.xml
  def index
    @content_types = ContentType.all(:conditions => ["code != ?", "A"])

    @cvc = GoogleChart::PieChart.new('350x200', "Total Views",  false)
    @ccc = GoogleChart::PieChart.new('350x200', "Total Spent",  false)


    @content_types.each do |ct|
      @articles = Article.joins(:views).where("content_source != ? AND article_age = ?","A",30)
      @type_articles = @articles.where(["content_type = ?",ct.code])


      next if @type_articles.count == 0
      @cvc.data ct.name, @type_articles.sum('pageviews').to_i, "#{ct.color}"
      @ccc.data ct.name, @type_articles.sum('total_cost').to_f, "#{ct.color}"

    end
    @type_views_chart = @cvc.to_url
    @type_cost_chart = @ccc.to_url




    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_types }
    end
  end

  def combined_content
    @content_types = ContentType.all(:conditions => ["code != ?", "A"])
    @content_sources = ContentSource.all(:conditions => ["code != ?", "A"])
    @combinations = Hash.new(0)

    @content_types.each do |ct|
      @ct_articles = Article.joins(:views).where("content_type =? AND article_age = ?",ct.code,30)
      next if @ct_articles.size == 0

      @content_sources.each do |cs|
        @combo = "#{ct.name}/#{cs.name}"
        @articles = @ct_articles.where("content_source = ?",cs.code)
        next if @articles.size == 0
        total_views = @articles.sum(:pageviews).to_i
        next if total_views == 0
        total_cost = @articles.sum(:total_cost).to_f
        avg_views = @articles.average(:pageviews).to_f
        avg_cost = @articles.average(:total_cost).to_f
        avg_effort = @articles.average(:effort).to_f
        cost_view = total_cost/total_views
        @combinations[@combo] = [total_views,total_cost,avg_views,avg_cost,avg_effort,cost_view]
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @content_types }
    end

  end

  def combined_content_month_view
    @content_types = ContentType.all(:conditions => ["code != ?", "A"])
    @content_sources = ContentSource.all(:conditions => ["code != ?", "A"])
    @combinations = Hash.new(0)
    @month = params[:month]
    @year = params[:year]
    @page_header = "internet.com Combined Content Report"
    @page_subhead = "#{@month}/#{@year}"

    @sd = Date.parse("#{@year}-#{@month}-01")
    @ed = @sd.end_of_month


    @content_types.each do |ct|
       @ct_articles = Article.joins(:views).where("content_type =? AND article_age = ?",ct.code,30)
        next if @ct_articles.size == 0
      @content_sources.each do |cs|
        @combo = "#{ct.name}/#{cs.name}"
        @articles = @ct_articles.where("content_source = ?",cs.code)
        next if @articles.size == 0
        total_views = @articles.sum(:pageviews).to_i
        next if total_views == 0
        total_cost = @articles.sum(:total_cost).to_f
        avg_views = @articles.average(:pageviews).to_f
        avg_cost = @articles.average(:total_cost).to_f
        avg_effort = @articles.average(:effort).to_f
        cost_view = total_cost/total_views
        @combinations[@combo] = [total_views,total_cost,avg_views,avg_cost,avg_effort,cost_view]
      end
    end



    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @content_types }
    end

  end





  def period_view
    @month = params[:month]
    @year = params[:year]


    @sd = Date.parse("#{@year}-#{@month}-01")
    @ed = @sd.end_of_month
    @page_name = "Content Type Overview for #{@sd.strftime("%m/%d/%y")} -- #{@ed.strftime("%m/%d/%y")}"

    @content_types = ContentType.all(:conditions => ["code != ?", "A"])
    @cvc = GoogleChart::PieChart.new('350x200', "Total Views",  false)
    @ccc = GoogleChart::PieChart.new('350x200', "Total Spent",  false)

    @content_types.each do |ct|
      @month_articles = Article.joins(:views).where("pub_date IN (?) AND content_type != ? AND content_source != ? AND article_age = ?",@sd..@ed,"A","A",30)

      @type_articles = @month_articles.where(["content_type = ?",ct.code])
      next if @type_articles.count == 0
      @cvc.data ct.name, @type_articles.sum('pageviews').to_i, "#{ct.color}"
      @ccc.data ct.name, @type_articles.sum('total_cost').to_f, "#{ct.color}"
    end
    @type_views_chart = @cvc.to_url
    @type_cost_chart = @ccc.to_url


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_types }
    end
  end

  # GET /content_types/1
  # GET /content_types/1.xml
  def show
    @content_type = ContentType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @content_type }
    end
  end

  # GET /content_types/new
  # GET /content_types/new.xml
  def new
    @content_type = ContentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @content_type }
    end
  end

  # GET /content_types/1/edit
  def edit
    @content_type = ContentType.find(params[:id])
  end

  # POST /content_types
  # POST /content_types.xml
  def create
    @content_type = ContentType.new(params[:content_type])

    respond_to do |format|
      if @content_type.save
        format.html { redirect_to(@content_type, :notice => 'Content type was successfully created.') }
        format.xml  { render :xml => @content_type, :status => :created, :location => @content_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /content_types/1
  # PUT /content_types/1.xml
  def update
    @content_type = ContentType.find(params[:id])

    respond_to do |format|
      if @content_type.update_attributes(params[:content_type])
        format.html { redirect_to(@content_type, :notice => 'Content type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /content_types/1
  # DELETE /content_types/1.xml
  def destroy
    @content_type = ContentType.find(params[:id])
    @content_type.destroy

    respond_to do |format|
      format.html { redirect_to(content_types_url) }
      format.xml  { head :ok }
    end
  end
end
