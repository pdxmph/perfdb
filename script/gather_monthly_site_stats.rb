#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'


months = ["2011-02-01"]

class MonthlySite
  extend Garb::Resource
  metrics :pageviews, :unique_pageviews, :bounces
end

class MonthlyVisitor
  extend Garb::Resource
  metrics :visitors
end

Site.find(:all, :conditions => ["analytics_profile IS NOT NULL"]).each do |site|
  puts site.name
  profile = Garb::Profile.first(site.analytics_profile)


  months.each do |m|
    puts "\t#{m}"

    sd = Date.parse(m)
    ed = sd.end_of_month

    begin
      site_data = site.site_stats.find_or_create_by_month(sd)

      results = MonthlySite.results(profile, :start_date => sd, :end_date => ed)
      visitor_results = MonthlyVisitor.results(profile, :start_date => sd, :end_date => ed)

      site_data.pageviews = results.first.pageviews.to_i
      site_data.unique_pageviews = results.first.unique_pageviews.to_i
      site_data.bounces = results.first.bounces.to_i
      site_data.bouncerate = site_data.bounces.to_f/site_data.unique_pageviews
      site_data.visitors = visitor_results.first.visitors
      site_data.save
    rescue => ex
      puts "#{ex.class} --- #{ex.message}"
    end
  end
end
