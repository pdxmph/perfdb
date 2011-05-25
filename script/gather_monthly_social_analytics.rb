#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'
#require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'
require '/Users/mike/rails/perfdb/config/qs-garb-setup.rb'


updates = 0

def create_social_view(site,social_domain,start_date,end_date)

  report = Garb::Report.new(@profile,
  :start_date => start_date,
  :end_date => end_date)

  report.metrics :pageviews, :entrances, :bounces, :uniquepageviews, :visits
  report.dimensions :source
  report.sort :pageviews.desc
  report.filters :source.contains => "#{social_domain.domain}"
  total_entrances = 0.0
  total_pageviews = 0.0
  total_visits = 0.0
  total_bounces = 0.0
  total_unique_pageviews = 0.0

  report.results.each do |r|
    total_visits += r.visits.to_i
    total_pageviews += r.pageviews.to_f
    total_bounces += r.bounces.to_f
    total_entrances += r.entrances.to_f
    total_unique_pageviews += r.unique_views.to_f
  end

  social_stat = SocialStat.new(:site_id => site.id, :social_site_id => social_domain.id, :month => start_date)
  social_stat.pageviews = total_pageviews
  social_stat.unique_views = total_unique_pageviews
  social_stat.entrances = total_entrances
  social_stat.bounces = total_bounces
  social_stat.visits = total_visits
  social_stat.month = start_date

  unless social_stat.bounces == 0 || social_stat.entrances == 0
    social_stat.bouncerate = social_stat.bounces/social_stat.entrances.to_f
  else
    social_stat.bouncerate = 0
  end

  #puts social_stat.inspect
  social_stat.save!
end

sites = Site.find(:all, :conditions => ["analytics_profile IS NOT NULL"]) #AND is_cdev = ?","InfoStor",0])
#sites = Site.find(:all, :conditions => ["name = ?", "Enterprise Networking Planet"]) #AND is_cdev = ?","InfoStor",0])


start_dates = ["2010-04-01","2010-05-01","2010-06-01","2010-07-01","2010-08-01","2010-09-01","2010-10-01","2010-11-01","2010-12-01","2011-01-01","2011-02-01","2011-03-01"]

start_dates.each do |sd|
start_date = Date.parse(sd)
end_date = start_date.end_of_month


sites.each do |site|

  puts "***** #{site.name} ****"

  begin
    @profile = Garb::Profile.first(site.analytics_profile)
  rescue => ex
    puts "\t\t\t*** Error loading profile for #{site.name}: #{ex.message}"
  end


  SocialSite.all.each do |ss|
    unless SocialStat.find(:first, :conditions => ["month = ? AND social_site_id = ? AND site_id =?", start_date,ss.id,site.id])
      puts ss.name

      begin
        create_social_view(site,ss,start_date,end_date)
      rescue => ex
        puts "\t\t\t#{ex.class}: #{ex.message}"
      end
    end
  end
end
end
