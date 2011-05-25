class ContentType < ActiveRecord::Base
  include Figure
  include VerticalFigure
  
  has_many :articles
  has_many :views, :through => :articles

  def avg_30_views
    views = View.joins(:article).where(["articles.content_type_id = ? AND article_age = ?",self.id,30])
    return views.average(:pageviews)
  end

  def avg_effort
    views = View.joins(:article).where(["articles.content_type_id = ?",self.id])
    return views.average(:effort)
  end

  def avg_cost
    views = View.joins(:article).where(["articles.content_type_id = ?",self.id])
    return views.average(:total_cost)
  end

  def cost_view
    views = View.joins(:article).where(["articles.content_type_id = ? ",self.id])
    return views.sum(:total_cost).to_f/views.sum(:pageviews).to_f
  end

  def period_avg_30_views(start_date,end_date)
    views = View.joins(:article).where(["articles.content_type_id = ? AND article_age = ? AND articles.pub_date IN (?)",self.id,30,start_date..end_date])
    return views.average(:pageviews)
  end

  def period_avg_effort(start_date,end_date)
    views = View.joins(:article).where(["articles.content_type_id = ?  AND articles.pub_date IN (?)",self.id,start_date..end_date])
    return views.average(:effort)
  end

  def period_avg_cost(start_date,end_date)
    views = View.joins(:article).where(["articles.content_type_id = ?  AND articles.pub_date IN (?)",self.id,start_date..end_date])
    return views.average(:total_cost)
  end




end
