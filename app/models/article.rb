class Article < ActiveRecord::Base

  @last_month = (Date.today - 2.months).beginning_of_month
  @last_month_end = @last_month.end_of_month

  belongs_to :site
  belongs_to :editor
  belongs_to :author
  has_many :views
  belongs_to :content_type
  belongs_to :content_source


  scope :no_legacy, :conditions => ["legacy_content != ?",true]
  scope :repurps, :joins => [:content_source], :conditions => ['content_sources.code = ?', 'R']
  scope :agcon, :joins => [:content_source], :conditions => ['content_sources.code = ?', 'A']
  scope :freelance, :joins => [:content_source], :conditions => ['content_sources.code = ?', 'F']
  scope :no_repurps, :joins => [:content_source], :conditions => ['content_sources.code != ?', 'R']
  scope :no_agcon, :joins => [:content_source], :conditions => ['content_sources.code != ?', 'A']
  scope :no_news, :joins => [:content_source], :conditions => ['content_sources.code != ?', 'I']
  scope :internet_news, :joins => [:content_source], :conditions => ['content_sources.code = ?', 'I']
  scope :original, no_repurps.no_agcon.no_news
  scope :incomplete, :conditions => ["content_source_id IS NULL OR content_type_id IS NULL"]
  scope :complete, :conditions => ["content_source_id IS NOT NULL AND content_type_id IS NOT NULL"]
  scope :by_author, lambda { |author| where(["author_id = ?", author]) }
  scope :by_date, lambda { |date| where(["pub_date > ? AND pub_date < ?", Date.parse(date),Date.parse(date).end_of_month]) }
  scope :in_site, lambda { |site| where(["site_id = ?", site])}
  scope :in_vertical, lambda { |vertical| joins(:site).where(["sites.vertical_id = ?", vertical])}
  scope :not_totaled, :conditions => ["total_cost IS NULL"]
  scope :not_original, repurps.agcon
  
  # Views

  scope :views_30, :joins => [:views], :conditions => ['views.article_age = ?',30]
  scope :view_range, lambda { |age| joins(:views).where(['views.article_age <= ?',age]) }
  scope :contenttype, lambda { |type_id| where(:content_type_id => type_id) }
  scope :contensource, lambda { |source_id| where(:content_type_id => source_id) }
  scope :month_articles, lambda { |start| where(["pub_date IN (?)", Date.parse(start)..Date.parse(start).end_of_month]) }

  scope :agcon, :joins => [:content_source], :conditions => ['content_sources.code = ?', 'A']

  def age
    return (Date.today - self.pub_date).to_i
  end

  def has_stats_for(age)
    
    if self.views.find_by_article_age(age) 
      return true
    else
      return false
    end
    
  end

  def incomplete?
    if content_source == nil ||content_type == nil || effort == nil
      return true
    else
      return false
    end
  end


  def view_record_at(days)
    return self.views.find(:first, :conditions => ["article_age = ?",days])
  end

  def site_record_at(days)
    return self.site.site_stats.find(:first, :conditions => ["month = ?",(self.pub_date + days.days).beginning_of_month])
  end

  def gross_revenue_at(days)
    begin
      return self.view_record_at(days).revenue_generated
    rescue
      return 0
    end
  end
  
  
  def bounce_rate_at(days)
    return self.views.find(:first, :conditions => ["article_age = ?",days]).bouncerate
  end
  
  def lifetime_gross
    return self.views.sum(:revenue)
  end
  

  def lifetime_net_revenue
    return self.lifetime_gross - self.total_cost
  end


  def lifetime_cost_per_view
    return self.total_cost/self.all_recorded_views
  end


  def views_at(days)
    return self.views.where("article_age = ?",days).sum(:pageviews).to_i
  end

  def unique_views_at(days)
    return self.views.where("article_age = ?",days).sum(:unique_views)
  end

  def all_recorded_views
    return self.views.sum(:pageviews)
  end

  def all_recorded_unique_views
    return self.views.sum(:unique_views)
  end
  
  def all_recorded_revenue
    return self.views.sum(:revenue)
  end

  def bounce_rate_at(days)

    view = self.views.find(:first, :conditions => ["article_age = ?",days])

    begin
      return view.bouncerate
    rescue
      return 0
    end
  end

  def period_views(start_date,end_date)
    range = [30,(end_date - start_date).to_i].max
    return self.views.where("article_age <= ?",range).sum(:pageviews)
  end


  def period_gross_revenue(start_date,end_date)
    range = [30,(end_date - start_date).to_i].max

    total_revenue = 0

    article_views = self.views.where("article_age <= ?",range)

    article_views.each do |v|
      view_month = (v.article.pub_date + v.article_age).beginning_of_month
      #    rpv = v.article.site.month_revenue_per_view(view_month)
      rpv = v.article.site.period_gross_revenue_per_view(start_date,end_date)
      total_revenue += v.pageviews * rpv
    end
    return total_revenue
  end

  def period_net_revenue(start_date,end_date)

    return self.period_gross_revenue(start_date,end_date) - self.total_cost

  end


  def gross_30_day_revenue
    date = self.pub_date
    begin
      return self.site.month_revenue_per_view(self.pub_date.beginning_of_month) * self.views_at(30)
    rescue
      return 0
    end
  end


  def net_30_day_revenue
    date = self.pub_date
    return self.site.month_revenue_per_view(self.pub_date.beginning_of_month) * self.views_30_day - self.total_cost
  end


  def gross_30_day_revenue_per_view
    return self.site.month_revenue_per_view(self.pub_date.beginning_of_month)
  end

  def net_30_day_revenue_per_view
    return self.site.month_revenue_per_view(self.pub_date.beginning_of_month) - self.cost_per_view_30
  end

  def views_30_day
    return self.views.sum('pageviews', :conditions => ["article_age = 30"]).to_i
  end

  def views_60_day
    return self.views.sum('pageviews', :conditions => ["article_age <= 60"]).to_i
  end

  def views_90_day
    return self.views.sum('pageviews', :conditions => ["article_age <= 90"]).to_i
  end

  def views_120_day
    return self.views.sum('pageviews', :conditions => ["article_age <= 120"]).to_i
  end

  def unique_views_thirty_day
    return self.views.sum('unique_views', :conditions => ["article_age <= 30"]).to_i
  end

  def unique_views_sixty_day
    return self.views.sum('unique_views', :conditions => ["article_age <= 60"]).to_i
  end

  def unique_views_ninety_day
    return self.views.sum('unique_views', :conditions => ["article_age <= 90"]).to_i
  end


  #### make this into a function that takes a parameter
  def bouncerate_30_day
    begin
      view = View.find(:first, :conditions => ["article_age = ? AND article_id = ?", 30, self.id])
      return view.bounces.to_f / view.entrances.to_f
    rescue
      return 0
    end
  end


  def full_cost

    if self.content_source == "I"
      article_effort = 3.5
    else
      article_effort = self.effort
    end

    if self.effort == nil
      article_effort = 1
    end

    return (site.editor.hourly_cost * article_effort) + self.cost
  end

  def cost_per_view(length)
    total_views = View.sum("pageviews", :conditions => ["article_age <= ? AND article_id = ?", length, self.id])

    if self.full_cost == nil
      return "Cost error"
    else
      return sprintf("%.2f",self.full_cost/total_views)
    end
  end

  def cost_per_view_30
    total_views = View.sum("pageviews", :conditions => ["article_age = ? AND article_id = ?", 30, self.id])

    if self.full_cost == nil
      return "Cost error"
    else
      return self.full_cost.to_f/total_views.to_f
    end
  end




end
