require "rubygems"
require "google_chart"


class SitesController < ApplicationController

  # caches_page :monthly_content, :monthly_author_report, :show_month, :app_index



  def app_index
    @total_articles = Article.all.count
    @incomplete_articles = Article.incomplete.count
    @recorded_views = View.all.count
    @total_writers = Author.all.count
    @total_editors = Editor.all.count
    @total_sites = Site.all.count

    respond_to do |format|
      format.html # index.html.erb

    end
  end


  # GET /sites
  # GET /sites.xml

  def index
    @sites = Site.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  def perfdb_models

    @page_header = "Content Performance Database Models"
    @page_subhead = Date.today.strftime("%B %Y")
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sites/1
  # GET /sites/1.xml


  def show
      @site = Site.find(params[:id])
      @id = params[:id]


      @start_date = Date.parse("2010-05-01")
      @end_date = Date.parse("2010-09-30")

      @dates = @start_date.strftime("%m/%d/%Y") + " — " + @end_date.strftime("%m/%d/%Y")
   
      @revenue_table = @site.revenue_report(@start_date,@end_date)
      @top_bottom_articles = @site.article_performance_report(@start_date,@end_date)
      @authors = @site.author_list(@start_date,@end_date)



      @start = "#{@year}-#{@month}-01"


      @page_name = "Site Overview for #{@site.name}"
      @page_header = @site.name
      @page_subhead = "Cumulative Report for #{@dates}"


    #  @authors = @site.cumulative_authors



      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @site }
      end
  end

  
   def show_month
    @site = Site.find(params[:id])
    @id = params[:id]
    @month = params[:month]
    @year = params[:year]
   
    @start_date = Date.parse("#{@year}-#{@month}-01")
    @end_date = @start_date.end_of_month
    
     
    @revenue_table = @site.revenue_report(@start_date,@end_date)
    @top_bottom_articles = @site.article_performance_report(@start_date,@end_date)
    @authors = @site.author_list(@start_date,@end_date)


    @page_name = "Site Overview for #{@site.name}"
    @page_header = @site.name

    @page_subhead = "#{@revenue_table.new_articles_count} new articles for #{@month}/#{@year}"


    
 

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site }
    end
  end

  def monthly_author_report
     @site = Site.find(params[:id])
     @id = params[:id]
     @month = params[:month]
     @year = params[:year]
     @date = "#{@year}-#{@month}-01"
     @authors = @site.authors_by_month(@date)
     @page_name = "Author Overview for #{@site.site_name}"
     @page_header = @site.site_name
     @page_subhead = "#{@month}/#{@year}"
   end

  def monthly_content
    @site = Site.find(params[:id])
    @month = params[:month]
    @year = params[:year]

    @date = "#{@year}-#{@month}-01"
    
    @start_date = Date.parse(@date)
    @end_date = @start_date.end_of_month

    @page_name = "Monthly Content Overview for #{@site.name} (#{@month}/#{@year})"
    @page_header = "#{@site.name}"
    @page_subhead = "Content Overview (#{@month}/#{@year})"

    # @type_reports = @site.month_content_type_report(@date)
    #     @source_reports = @site.month_content_source_report(@date)

    @type_reports = @site.period_content_type_report(@start_date,@end_date)
    @source_reports = @site.period_content_source_report(@start_date,@end_date)

    # google charts:
    #    @ctnr = GoogleChart::BarChart.new('350x200', "Gross Revenue",  false)
    @ctv = GoogleChart::PieChart.new('350x200', "Gross Revenue",  false)
    @ctc = GoogleChart::PieChart.new('350x200', "Total Spent",  false)

    old_content_views = 0
    @type_reports.each do |report|
      @ctv.data report.name, report.gross_revenue, report.color
      @ctc.data report.name, report.total_content_cost, report.color
      #     @ctnr.data report[:name], [report[:net_revenue].to_i], report[:color]
    end



    @type_view_chart = @ctv.to_url
    @type_cost_chart = @ctc.to_url
    #   @type_net_revenue_chart = @ctnr.to_url

    respond_to do |format|
      format.html # index.html.erb
    end


  end

  def period_content
    @site = Site.find(params[:id])
    @month = params[:month]
    @year = params[:year]

    @date = "#{@year}-#{@month}-01"
    
    @start_date = Date.parse("2010-05-01")
    @end_date = Date.parse("2010-09-30")

    @page_name = "Lifetime Content Overview for #{@site.name}"
    @page_header = "Lifetime Content Overview for #{@site.name}"
#    @page_subhead = "Content Overview (#{@month}/#{@year})"

    # @type_reports = @site.month_content_type_report(@date)
    #     @source_reports = @site.month_content_source_report(@date)

    @type_reports = @site.period_content_type_report(@start_date,@end_date)
    @source_reports = @site.period_content_source_report(@start_date,@end_date)

    # google charts:
    #    @ctnr = GoogleChart::BarChart.new('350x200', "Gross Revenue",  false)
    @ctv = GoogleChart::PieChart.new('350x200', "Gross Revenue",  false)
    @ctc = GoogleChart::PieChart.new('350x200', "Total Spent",  false)

    old_content_views = 0
    @type_reports.each do |report|
      @ctv.data report.name, report.gross_revenue, report.color
      @ctc.data report.name, report.total_content_cost, report.color
      #     @ctnr.data report[:name], [report[:net_revenue].to_i], report[:color]
    end



    @type_view_chart = @ctv.to_url
    @type_cost_chart = @ctc.to_url
    #   @type_net_revenue_chart = @ctnr.to_url

    respond_to do |format|
      format.html # index.html.erb
    end


  end





  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to(@site, :notice => 'Site was successfully created.') }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to(@site, :notice => 'Site was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end


  def monthly_site_author_report
    @site = Site.find(params[:id])
    @month = params[:month]
    @year = params[:year]

    @sd = Date.parse("#{@year}-#{@month}-01")
    @start = "#{@year}-#{@month}-01"
    @ed = @sd.end_of_month

    @page_header = "#{@site.site_name}"
    @page_subhead = "Author Report (#{@month}/#{@year})"

    @authors = @site.authors_by_month(@start)


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @content_sources }
    end
  end

  


end
