class Site < ActiveRecord::Base

  include Figure
  belongs_to :channel
  has_many :articles
  has_many :site_stats
  has_many :seo_stats
  has_many :search_stats
  has_many :views, :through => :articles
  belongs_to :editor
  has_many :authors, :through => :articles
  belongs_to :vertical

  scope :ga, :conditions => ["analytics_profile IS NOT NULL"]
  scope :cdev, :conditions => ["is_cdev = ?",1]
  scope :agcon_sites, :conditions => ["agcon_cost IS NOT NULL"]
  scope :non_cdev, :conditions => ["is_cdev = ? AND site_name != ?",0, "InfoStor"]
  scope :reportable, :conditions => ["analytics_profile IS NOT NULL AND is_reportable != ?",0]
  scope :priority, :conditions => ["priority_report IS TRUE"]
  scope :core, :conditions => ["is_core = ?",1]


  def month_pageviews(date)
    site_stat = self.site_stats.find_by_month(date)
    if site_stat == nil
      return nil
    end

    unless site_stat.pageviews == nil
      return site_stat.pageviews
    else
      return 0
    end

  end


  def month_revenue(date)

    site_stat = self.site_stats.find_by_month(date)

    if site_stat == nil
      return nil
    end

    unless site_stat.revenue == nil
      return site_stat.revenue
    else
      return 0
    end

  end


  # this report is reusable for overview, monthly and specific period views ...

  def revenue_report(start_date,end_date)
    report = OpenStruct.new

    days_range = [30,(end_date - start_date).to_i].max

    articles = self.articles.no_agcon.where("pub_date IN (?)",start_date..end_date)
    articles_and_views = articles.joins(:views).where("views.article_age <= ?",days_range)
    stats = self.site_stats.where("month IN (?)", start_date..end_date)

    report.new_articles_count = articles.count

    report.gross_revenue =  stats.sum(:revenue)
    report.total_content_cost = articles.sum(:total_cost)
    report.average_content_cost = articles.average(:total_cost)

    report.net_revenue = report.gross_revenue - report.total_content_cost

    report.total_views = stats.sum(:pageviews).to_i
    report.new_content_views = articles_and_views.sum(:pageviews).to_i
    report.old_content_views = report.total_views - report.new_content_views


    report.gross_revenue_per_view = report.gross_revenue/report.total_views
    report.old_content_revenue = report.gross_revenue_per_view * report.old_content_views

    report.new_content_avg_views = report.new_content_views/report.new_articles_count

    report.new_content_gross_revenue = report.gross_revenue_per_view * report.new_content_views
    report.new_content_net_revenue = report.new_content_gross_revenue - report.total_content_cost

    report.new_content_avg_gross_revenue = report.new_content_gross_revenue/report.new_articles_count
    report.new_content_avg_net_revenue = report.new_content_net_revenue/report.new_articles_count

    return report


  end

  # this report is reusable for overview, monthly and specific periods

  def article_performance_report(start_date,end_date)

    report = OpenStruct.new
    period_articles = self.articles.no_agcon.where("pub_date IN (?)",start_date..end_date)

    article_list = []

    period_articles.each { |a| article_list << Hash[:title => a.title, :pub_date => a.pub_date, :views => a.period_views(start_date,end_date), :net_revenue => a.period_net_revenue(start_date,end_date)] }


    report.top_revenue = article_list.sort_by { |a| a[:net_revenue] }.reverse
    report.bottom_revenue = article_list.sort_by { |a| a[:net_revenue] }
    report.top_views = article_list.sort_by { |a| a[:views] }.reverse
    report.bottom_views = article_list.sort_by { |a| a[:views] }

    return report

  end


  def monthly_report(date)
    report = {}

    report[:total_revenue] = monthly_revenue(date).to_f
    report[:new_articles] = monthly_article_count(date).to_i
    report[:total_views] = month_all_content_views(date).to_i
    report[:old_content_views] = month_old_content_views(date).to_i
    report[:new_content_views] = month_new_content_views(date).to_i
    report[:new_content_avg_views] = month_new_content_avg_views(date).to_i
    report[:old_content_revenue] = month_old_content_revenue(date).to_f
    report[:new_content_revenue] = month_new_content_revenue(date).to_f
    report[:months_authors] = authors_by_month(date)
    report[:total_content_cost] = month_total_spent(date).to_f
    report[:average_content_cost] = month_average_spent(date).to_f
    report[:new_content_avg_revenue] = report[:new_content_revenue] / report[:new_articles]
    report[:revenue_per_view] = monthly_revenue(date).to_f/month_all_content_views(date)
    report[:new_content_net_revenue] = month_new_content_net_revenue(date)
    report[:new_content_avg_net_revenue] = report[:new_content_net_revenue] / report[:new_articles]
    return report
  end


  # def article_performance_report(start_date,end_date)
  #     report = {}
  #     revenue_performance_list = []
  #     articles = self.articles.joins(:views).where("pub_date IN (?)", start_date..end_date)
  #     articles.each { |a| revenue_performance_list << Hash[:title => a.title, :revenue => a.net_30_day_revenue] }
  #     report[:top_views] = articles.order("pageviews DESC")
  #     report[:bottom_views] = articles.order("pageviews ASC")
  #     report[:top_revenue] = revenue_performance_list.sort_by { |a| a[:revenue] }.reverse
  #     report[:bottom_revenue] = revenue_performance_list.sort_by { |a| a[:revenue] }
  #     return report
  #   end



  def monthly_article_count(date)
    return self.articles.no_agcon.by_date(date).count
  end



  def monthly_article_performance_report(date)

    report = {}
    revenue_performance_list = []

    months_articles = self.articles.original.month_articles(date.to_s).views_30

    months_articles.each { |a| revenue_performance_list << Hash[:title => a.title, :revenue => a.net_30_day_revenue] }

    report[:top_views] = months_articles.order("pageviews DESC")
    report[:bottom_views] = months_articles.order("pageviews ASC")
    report[:top_revenue] = revenue_performance_list.sort_by { |a| a[:revenue] }.reverse
    report[:bottom_revenue] = revenue_performance_list.sort_by { |a| a[:revenue] }

    return report
  end


  def monthly_revenue(date)

    working_date = date.beginning_of_month

    stat = SiteStat.find(:first, :conditions => ["site_id = ? and month = ? ", self.id,working_date])

    unless stat == nil  || stat.revenue == nil
      return stat.revenue
    else
      return self.site_stats.find(:last, :order => "month asc", :conditions => ["revenue IS NOT NULL"]).revenue
    end
  end



  def month_all_content_views(date)
    views = SiteStat.find(:first, :conditions => ["month = ? AND site_id = ?",date,self.id])
    return views.pageviews.to_i
  end

  def period_total_spent(start_date,end_date)

    return self.articles.where("pub_date IN (?)",start_date..end_date).sum(:total_cost)

  end


  def period_all_content_views(start_date,end_date)
    return self.site_stats.where("month IN (?)",start_date..end_date).sum(:pageviews)
  end

  def period_gross_revenue(start_date,end_date)
    date = start_date.beginning_of_month
    all_rev = 0

    until date > end_date.end_of_month
      all_rev += self.monthly_revenue(date)
      date += 1.month
    end
    return all_rev
  end

  def period_net_revenue(start_date,end_date)
    return period_gross_revenue(start_date,end_date) - period_total_spent(start_date,end_date)
  end


  def period_gross_revenue_per_view(start_date,end_date)
    return period_gross_revenue(start_date,end_date)/period_all_content_views(start_date,end_date)
  end



  def month_freelance_content_views(date)
    unless date.class == Date
      @sd = Date.parse(date)
    else
      @sd = date
    end
    @ed = @sd.end_of_month
    articles = self.articles.freelance.joins(:views).where("article_age = ? AND pub_date IN (?)", 30, @sd..@ed)
    return articles.sum(:pageviews).to_i
  end


  def month_new_content_views(date)
    unless date.class == Date
      @sd = Date.parse(date)
    else
      @sd = date
    end
    @ed = @sd.end_of_month
    articles = self.articles.no_agcon.joins(:views).where("article_age = ? AND pub_date IN (?)", 30, @sd..@ed)
    return articles.sum(:pageviews).to_i
  end

  def month_new_content_avg_views(date)
    @sd = Date.parse(date)
    @ed = @sd.end_of_month
    articles = self.articles.no_agcon.joins(:views).where("article_age = ? AND pub_date IN (?)", 30, @sd..@ed)
    return articles.average(:pageviews).to_f

  end





  def month_old_content_views(date)
    return month_all_content_views(date) - month_new_content_views(date)
  end

  def month_revenue_per_view(date)
    return  monthly_revenue(date) / month_all_content_views(date)
  end



  def month_old_content_revenue(date)
    month_old_content_views(date) * month_revenue_per_view(date)
  end

  def month_new_content_revenue(date)
    month_new_content_views(date) * month_revenue_per_view(date)
  end

  def month_new_content_net_revenue(date)
    month_new_content_views(date) * month_revenue_per_view(date) - month_total_spent(date).to_f
  end



  def monthly_revenue_report(date)
    report = {}
    report[:new_content] = month_new_content_views(date) * month_revenue_per_view(date)
    report[:old_content] = month_old_content_views(date) * month_revenue_per_view(date)
    report[:total] = SiteStat.find(:first, :conditions => ["site_id = ? and month = ?", self.id,date]).revenue
    report[:per_view] =  monthly_revenue(date) / month_all_content_views(date)
    return report
  end


  def average_pageviews(start_date,end_date)
    @sd = Date.parse(start_date)
    @ed = Date.parse(end_date)
    articles = self.articles.no_agcon.joins(:views).where("article_age = ? AND pub_date IN (?)", 30, @sd..@ed)
    return articles.average(:pageviews)
  end

  def month_total_spent(date)

    unless date.class == Date
      @sd = Date.parse(date)
    else
      @sd = date
    end


    @ed = @sd.end_of_month
    articles = self.articles.no_agcon.where(["pub_date IN (?)",@sd..@ed])
    return articles.sum(:total_cost)

  end

  def month_freelance_spent(date)

    unless date.class == Date
      @sd = Date.parse(date)
    else
      @sd = date
    end


    @ed = @sd.end_of_month
    articles = self.articles.freelance.where(["pub_date IN (?)",@sd..@ed])
    return articles.sum(:total_cost)

  end


  def month_average_spent(date)
    sd = Date.parse(date)
    ed = sd.end_of_month
    articles = self.articles.no_agcon.where(["pub_date IN (?)",sd..ed])

    return articles.average(:total_cost)

  end

  def month_total_effort(date)
    sd = Date.parse(date)
    ed = sd.end_of_month
    articles = self.articles.no_agcon.where(["pub_date IN (?)",sd..ed])
    return articles.sum(:effort)
  end

  def month_average_effort(date)
    sd = Date.parse(date)
    ed = sd.end_of_month
    articles = self.articles.no_agcon.where(["pub_date IN (?)",sd..ed])

    return articles.average(:effort)

  end


  def author_list(start_date,end_date)
    authors = []
    self.articles.original.where("pub_date IN (?)",start_date..end_date).each { |a| authors << a.author }
    return authors.uniq
  end


  def authors_by_month(date)
    sd = Date.parse(date)
    ed = sd.end_of_month

    authors = []

    self.articles.original.by_date(date.to_s).each { |a| authors << a.author }

    unless authors.size == 0
      return authors.uniq
    else
      return 0
    end
  end



  def month_articles(date)
    @sd = Date.parse(date)
    @ed = @sd.end_of_month
    return self.articles.no_agcon.where(["pub_date IN (?)", @sd..@ed])
  end



  def update_candidates(age)
    updates = []

    articles = Article.find(:all, :conditions => ["pub_date >= ?", Date.today - age.days])

    articles.each do |a|
      unless View.find(:first, :conditions => ["article_id = ? AND article_age = ?",a.id,age])
        updates << a
      end

      return updates.length

    end

  end


  def month_content_type_report(start_date,end_date)
    report_list = []

    ContentType.all.each do |ct|
      next if ct.month_articles_by_site(self.id).count == 0
      report_list << ct.site_report(self.id,start_date,end_date)
    end

    return report_list

  end

  def period_content_type_report(start_date,end_date)
    report_list = []

    ContentType.all.each do |ct|
      next if ct.period_articles_by_site(self.id,start_date,end_date).count == 0
      report_list << ct.site_report(self.id,start_date,end_date)
    end

    return report_list

  end

  def period_content_source_report(start_date,end_date)
    report_list = []

    ContentSource.all.each do |ct|
      next if ct.period_articles_by_site(self.id,start_date,end_date).count == 0
      report_list << ct.site_report(self.id,start_date,end_date)
    end

    return report_list

  end









  def cumulative_content_type_report(start_date,end_date)
    report_list = []

    ContentType.all.each do |ct|
      next if ct.cumulative_articles_by_site(self.id,start_date,end_date).count == 0
      report_list << ct.cumulative_site_report(self.id,start_date,end_date)
    end

    return report_list

  end

  def month_content_source_report(start_date,end_date)
    report_list = []

    ContentSource.all.each do |cs|
      next if cs.month_articles_by_site(self.id,date).count ==0
      report_list << cs.month_site_report(self.id,date)
    end

    return report_list

  end

  def month_rpv(date)

    unless date.class == Date
      revenue_month = Date.parse(date).beginning_of_month
    else
      revenue_month = date
    end

    stat = self.site_stats.find(:first, :conditions => ["month = ?",revenue_month])


    begin
      return stat.revenue/stat.pageviews
    rescue
      return 0
    end

  end



end
