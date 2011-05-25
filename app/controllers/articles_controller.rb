class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  
  
  
  
  def sixty_day_articles
    @articles = Article.original.complete.no_legacy.where("pub_date < ?", Date.today - 60.days)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
    
  end
  
  
  
  
  
  
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
    def network_top_articles
       @month = params[:month]
        @year = params[:year]

        @page_header = "Internet.com Top Articles"


        @start = ("#{@year}-#{@month}-01")

        @sd = Date.parse("#{@year}-#{@month}-01")
        @ed = @sd.end_of_month

        @month_articles = Article.month_articles(@start).joins(:views).where(["views.article_age = 30 AND content_source != ? AND views.pageviews > ?","A",0])
        @page_subhead = "#{@month}/#{@year} (#{@month_articles.count})"
       

        @top_articles = @month_articles.joins(:views).order("pageviews DESC").limit(10)
        @bottom_articles = @month_articles.joins(:views).order("pageviews ASC").limit(10)

        @article_performance_list = []

        @month_articles.each do |a|
          next unless a.cost_per_view_30.to_f > 0 
          @article_performance_list << Hash[:title => a.title, :cost_view => a.cost_per_view_30, :site => a.site.site_name]

        end

        @top_performers = @article_performance_list.sort_by { |a| a[:cost_view] }
        @bottom_performers = @article_performance_list.sort_by { |a| a[:cost_view] }.reverse
      
      
    end
    
    
    
  
end
