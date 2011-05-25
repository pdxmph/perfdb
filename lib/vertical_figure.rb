module VerticalFigure

  def upname
    return self.name.upcase
  end

  def month_articles_by_vertical(vertical,date)
    return self.articles.in_vertical(vertical).original.by_date(date).views_30
  end

  def month_views(vertical,date)
    return self.month_articles_by_vertical(vertical,date).sum(:pageviews).to_i
  end

  def month_spent_for_vertical(vertical,date)
    articles = self.articles.in_vertical(vertical).original.by_date(date).views_30
    return articles.sum(:total_cost).to_f
  end

  def month_gross_revenue_for_vertical(vertical,date)
    vertical = Vertical.find(vertical)
    articles = self.month_articles_by_vertical(vertical,date)
    rpv = vertical.month_revenue_per_view(date).to_f
    gross_revenue = rpv *  self.month_views(vertical,date).to_f
    return gross_revenue.to_f
  end

  def month_net_revenue_for_vertical(vertical,date)
    return self.month_gross_revenue_for_vertical(vertical,date) - self.month_spent_for_vertical(vertical,date).to_f
  end


  def month_gross_revenue_per_view(vertical,date)
    return self.month_gross_revenue_for_vertical(vertical,date)/self.month_views(vertical,date).to_f
  end


  def month_net_revenue_per_view(vertical,date)
    return self.month_net_revenue_for_vertical(vertical,date)/self.month_views(vertical,date).to_f
  end


  def month_vertical_cost_view(vertical,date)
    views =  self.month_articles_by_vertical(vertical,date).sum(:pageviews)
    cost =  self.month_articles_by_vertical(vertical,date).sum(:total_cost)
    return cost.to_f/views.to_f
  end

  def month_vertical_average_effort(vertical,date)
    return self.month_articles_by_vertical(vertical,date).average(:effort).to_f
  end


  def month_vertical_average_cost(vertical,date)
    return self.month_articles_by_vertical(vertical,date).average(:total_cost).to_f
  end


  

  def month_vertical_report(vertical,date)
    report = {}
    vertical = Vertical.find(vertical)

    articles = self.articles.in_vertical(vertical).original.by_date(date).views_30

    if articles.count == 0
      return false
    end

    revenue = 0

    rpv = vertical.month_gross_revenue_per_view(date).to_f

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





end

