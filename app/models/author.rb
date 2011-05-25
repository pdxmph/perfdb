class Author < ActiveRecord::Base
  include Figure
  has_many :articles
  has_many :editors, :through => :articles

  scope :news_staff, :conditions => {:is_internet_news => 1}


  def site_report_by_date(date,site_id)
    report = {}
    sd = Date.parse(date)

    articles = self.articles.no_agcon.in_site(site_id).by_date(date).views_30
    
#    revenue = 0 
    
#    articles.each { |a| revenue += a.revenue }

    report[:total_views] = articles.sum(:pageviews)
    report[:average_views] = articles.average(:pageviews)
    report[:total_cost] = articles.sum(:total_cost)
    report[:average_effort] = articles.average(:effort)
    report[:total_articles] = articles.count
    report[:cost_view] = articles.sum(:total_cost).to_f/articles.sum(:pageviews).to_f
    report[:revenue_per_view] = month_revenue_per_view(site_id,date)
 #   report[:revenue] = revenue
    return report
  
  end

  def month_revenue_per_view(site,date)
    site = Site.find(site)
    articles = self.articles.in_site(site).no_agcon.no_news.by_date(date).views_30
    revenue = 0.0
    articles.each { |a| revenue += a.revenue }
    views = articles.sum(:pageviews)
    
    return revenue/views
    
  end


  def month_site_article_revenue(site,date)
    sd = Date.parse(date)
    ed = sd.end_of_month
    
    total_revenue = 0
    
    self.articles.where(["pub_date IN (?) and site_id = ?", sd..ed,site]).each { |a| total_revenue += a.revenue }
    return total_revenue
    
  end
  
  



end
