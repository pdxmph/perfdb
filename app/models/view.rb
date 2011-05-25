class View < ActiveRecord::Base
  set_table_name 'views'
  belongs_to :article


  scope :no_revenue, :conditions => ["revenue IS NULL"]


  def revenue_month
    view_date = self.capture_date
    month_halfway = (Time.days_in_month(view_date.month, view_date.year))/2

    if view_date.day > month_halfway
      return view_date.beginning_of_month
    else
      return view_date.beginning_of_month - 1.month
    end

  end

  def revenue_knowable?
    begin
      rev_month = self.revenue_month
      rev_site = self.article.site

      unless rev_site.month_revenue(rev_month) == nil
        return true
      else
        return false
      end
    rescue
      return false
    end
  end


  def revenue_generated

    if self.revenue_knowable? == true
      rev_site = self.article.site
      rpv = rev_site.month_rpv(self.revenue_month)
      return self.pageviews * rpv.to_f
    else
      return 0
    end
  end


  def hi_rez_revenue
    
    vpd = self.pageviews/30

    current_rev_month = self.capture_date.beginning_of_month
    previous_rev_month = (self.capture_date - 1.month).beginning_of_month

    if current_view = self.article.site.site_stats.find(:first, :conditions => ["month = ?", current_rev_month]) && previous_view = self.article.site.site_stats.find(:first, :conditions => ["month = ?", previous_rev_month])

      current_month_days = self.capture_date - self.capture_date.beginning_of_month
      previous_month_days = 30 - current_month_days
      
    cm_views = (current_month_days * vpd).to_i
    pm_views = (previous_month_days * vpd).to_i
    
    cmrpv = current_view.revenue_per_view
    pmrpv = previous_view.revenue_per_view
    
    cm_rev = cmrpv * cm_views
    pm_rev = pmrpv * pm_views
    
    return cm_rev + pm_rev
      
    else
      return 0
    end




  end




end
