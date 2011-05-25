module Figure

  def upname
    return self.name.upcase
  end

  def month_articles_by_site(site,date)
    return self.articles.in_site(site).original.by_date(date).views_30
  end

  def period_articles_by_site(site,start_date,end_date)
    return self.articles.in_site(site).original.where("pub_date IN (?)", start_date..end_date)
  end
  
  def month_views(site,date)
    return self.month_articles_by_site(site,date).sum(:pageviews).to_i
  end

  def month_spent_for_site(site,date)
    articles = self.articles.in_site(site).original.by_date(date).views_30
    return articles.sum(:total_cost).to_f
  end

  def month_gross_revenue_for_site(site,date)
    site = Site.find(site)
    articles = self.month_articles_by_site(site,date)
    rpv = site.month_revenue_per_view(date).to_f
    gross_revenue = rpv *  self.month_views(site,date).to_f
    return gross_revenue.to_f
  end

  def month_net_revenue_for_site(site,date)
    return self.month_gross_revenue_for_site(site,date) - self.month_spent_for_site(site,date).to_f
  end

  def month_gross_revenue_per_view(site,date)
    return self.month_gross_revenue_for_site(site,date)/self.month_views(site,date).to_f
  end

  def month_net_revenue_per_view(site,date)
    return self.month_net_revenue_for_site(site,date)/self.month_views(site,date).to_f
  end


  def month_site_cost_view(site,date)
    views =  self.month_articles_by_site(site,date).sum(:pageviews)
    cost =  self.month_articles_by_site(site,date).sum(:total_cost)
    return cost.to_f/views.to_f
  end

  def month_site_average_effort(site,date)
    return self.month_articles_by_site(site,date).average(:effort).to_f
  end


  def month_site_average_cost(site,date)
    return self.month_articles_by_site(site,date).average(:total_cost).to_f
  end


  def site_report(site,start_date,end_date)
    report = OpenStruct.new
    report.name = self.name

    days_range = [30,(end_date - start_date).to_i].max
    report.days_range = days_range
    articles = self.articles.in_site(site).original.where("pub_date IN (?)",start_date..end_date)
    articles_and_views = articles.joins(:views).where("views.article_age <= ?",days_range)
    report.total_articles = articles.count
    report.total_views = articles_and_views.sum(:pageviews)
    report.average_effort = articles.average(:effort)
    article_views = []

    articles.each { |a| article_views << a.period_views(start_date,end_date)}

    # calculate article metrics
    sum_articles_views = 0
    article_views.each { |av| sum_articles_views += av }
    report.total_views = sum_articles_views
    report.average_views = sum_articles_views/report.total_articles
    report.total_content_cost = articles.sum(:total_cost)
    report.average_content_cost = articles.average(:total_cost)


    # calculate aggregate revenue
    gross_revenue = 0
    articles.each { |a| gross_revenue += a.period_gross_revenue(start_date,end_date) }
    report.gross_revenue = gross_revenue

    report.net_revenue = report.gross_revenue - report.total_content_cost

    begin
      report.gross_revenue_per_view = report.gross_revenue/report.total_views
      report.net_revenue_per_view = report.net_revenue/report.total_views

      report.cost_per_view = report.total_content_cost / report.total_views
    rescue
    end

    # report.new_content_avg_gross_revenue = report.new_content_gross_revenue/report.new_articles_count
    # report.new_content_avg_net_revenue = report.new_content_net_revenue/report.new_articles_count


    if self.methods.include?("color")
      report.color = self.color
    end


    return report

  end







  def month_vertical_report(site,date)
    report = {}
    site = Site.find(site)

    articles = self.articles.in_vertical(vertical).original.by_date(date).views_30

    if articles.count == 0
      return false
    end

    revenue = 0

    rpv = vertical.month_revenue_per_view(date).to_f

    report[:name] = name
    report[:all_other_views] = vertical.month_old_content_views(date)

    # taken straight from the articles collected
    report[:total_articles] = articles.count
    report[:total_views] =  articles.sum(:pageviews)
    report[:total_cost] = articles.sum(:total_cost)
    report[:avg_effort] = articles.average(:effort).to_f
    report[:avg_30_day_views] = articles.average(:pageviews).to_i
    report[:avg_total_cost] = articles.average(:total_cost).to_f
    report[:avg_30_day_bounce_rate] = articles.average(:bouncerate).to_f

    # derived
    report[:gross_revenue] = rpv *  report[:total_views]
    report[:net_revenue] = report[:gross_revenue] - report[:total_cost]
    report[:gross_revenue_per_view] = report[:gross_revenue]/report[:total_views]
    report[:net_revenue_per_view] = report[:net_revenue]/report[:total_views]
    report[:cost_view] =  report[:total_cost]/report[:total_views]


    if self.methods.include?("color")
      report[:color] = self.color
    end

    return report
  end





  def performance_history(site,date,age)
    report = {}

    report[:name] = self.name
    report[:month] = Date.parse(date).strftime("%b")


    if self.methods.include?("color")
      report[:color] = self.color
    end


    articles = self.articles.in_site(site).no_agcon.by_date(date)

    if articles.count == 0
      return 0
    end

    total_spent = articles.sum(:total_cost)
    views = articles.joins(:views).where("article_age <= ?",age)

    total_views = views.sum(:pageviews)
    stat = Site.find(site).site_stats.find_by_month(date)
    rvp = stat.revenue/stat.pageviews

    report[:total_views] = total_views
    report[:total_spent] = articles.sum(:total_cost)
    report[:gross_revenue] = total_views * rvp
    report[:net_revenue] = report[:gross_revenue] - total_spent

    report[:gross_revenue_per_view] = report[:gross_revenue]/stat.pageviews
    report[:net_revenue_per_view] = report[:net_revenue]/stat.pageviews

    return report


  end

  def period_gross_revenue(site_id,start_date,end_date)

    total_revenue = 0

    if self.class == Article
      views = self.views.where("capture_date IN (?)",start_date..end_date)

      views.each do |v|
        rvp = v.article.site.month_revenue_per_view(start_date)
        total_revenue += v.pageviews * rvp
      end

      return total_revenue

    else
      views = self.views.joins(:article).where("capture_date IN (?) AND articles.site_id = ?", start_date..end_date,site_id)

      views.each do |v|
        rvp = v.article.site.month_revenue_per_view(start_date)
        total_revenue += v.pageviews * rvp
      end

      return total_revenue

    end

  end

  def period_net_revenue(site_id,start_date,end_date)
    calc_gross_revenue = self.period_gross_revenue(site_id,start_date,end_date)

    if self.class == Article
      return calc_gross_revenue - self.total_cost
    else
      articles = self.articles.where("pub_date IN (?) AND site_id = ?", start_date..end_date,site_id)
      return calc_gross_revenue - articles.sum(:total_cost)
    end

  end


  # def month_site_report(site,date)
  #    report = {}
  #    site = Site.find(site)
  #
  #    articles = self.articles.in_site(site).original.by_date(date).views_30
  #
  #    if articles.count == 0
  #      return false
  #    end
  #
  #    revenue = 0
  #
  #    rpv = site.month_revenue_per_view(date).to_f
  #
  #    report[:name] = name
  #    report[:all_other_views] = site.month_old_content_views(date)
  #
  #    # taken straight from the articles collected
  #    report[:total_articles] = articles.count
  #    report[:total_views] =  articles.sum(:pageviews)
  #    report[:total_cost] = articles.sum(:total_cost)
  #    report[:avg_effort] = articles.average(:effort).to_f
  #    report[:avg_30_day_views] = articles.average(:pageviews).to_i
  #    report[:avg_total_cost] = articles.average(:total_cost).to_f
  #    report[:avg_30_day_bounce_rate] = articles.average(:bouncerate).to_f
  #
  #    # derived
  #    report[:gross_revenue] = rpv *  report[:total_views]
  #    report[:net_revenue] = report[:gross_revenue] - report[:total_cost]
  #    report[:gross_revenue_per_view] = report[:gross_revenue]/report[:total_views]
  #    report[:net_revenue_per_view] = report[:net_revenue]/report[:total_views]
  #    report[:cost_view] =  report[:total_cost]/report[:total_views]
  #
  #
  #    if self.methods.include?("color")
  #      report[:color] = self.color
  #    end
  #
  #    return report
  #  end

end
