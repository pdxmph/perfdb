#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'

reporting_months = ["2010-05-01", "2010-06-01", "2010-07-01", "2010-08-01", "2010-09-01"]

Site.reportable.each do |s|

  puts "#{s.name}"

  reporting_months.each do |m|
    if stats = s.site_stats.find(:first, :conditions => ["month = ?", m])
      puts "\t" + m

      articles = s.articles.joins(:views).where("pub_date IN (?) AND views.article_age = ?", Date.parse(m)..Date.parse(m).end_of_month,30)

      puts "\t\tTotal Views: #{stats.pageviews.to_i}"
      puts "\t\tSite Bounce Rate: #{stats.bouncerate}"
      puts "\t\tNew Content Views: #{articles.sum(:pageviews).to_i}"
      puts "\t\t% of Views from New Content: #{articles.sum(:pageviews).to_f/stats.pageviews}"
      puts "\t\tAverage New Content Bounce Rate: #{articles.average(:bouncerate)}"

    end

  end
end