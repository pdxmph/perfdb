#!/usr/bin/env ruby

# use this to update all the articles

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

#RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'

updates = 0
reporting_intervals = [30,60,90,120,150,180,210,240,270,300,330,360]

def create_view(search_fragment,start_date,end_date,report_type,article_id,article_age)

rescue => ex
  puts "Error saving #{a.title}: #{ex.message} (#{ex.class})"

else

  report = Garb::Report.new(@profile,
  :start_date => start_date,
  :end_date => end_date)

  report.metrics :pageviews, :entrances, :bounces, :uniquepageviews
  report.dimensions :page_path, :page_title
  report.sort :pageviews.desc

  if report_type == "non_cdev"
    report.filters :page_title.contains => "#{search_fragment}"
  else
    report.filters :page_path.contains => "#{search_fragment}"
  end

  total_entrances = 0.0
  total_pageviews = 0.0
  total_bounces = 0.0
  total_unique_pageviews = 0.0

  report.results.each do |r|
    total_pageviews += r.pageviews.to_f
    total_bounces += r.bounces.to_f
    total_entrances += r.entrances.to_f
    total_unique_pageviews += r.unique_pageviews.to_f
  end

  view = View.new(:article => Article.find(article_id))
  view.pageviews = total_pageviews
  view.unique_views = total_unique_pageviews
  view.article_age = article_age
  view.entrances = total_entrances
  view.bounces = total_bounces
  view.capture_date = end_date

  unless view.bounces == 0 || view.entrances == 0
    view.bouncerate = view.bounces/view.entrances.to_f
  else
    view.bouncerate = 0
  end



  ### added 2/25/11
  begin
    if view.revenue_knowable? == true
      view.revenue = view.revenue_generated.to_f
    end
  rescue => ex
    puts "\t\tError: #{ex.message} -- #{ex.class}"
  end

  ###

  view.save!
end

sites = Site.find(:all, :conditions => ["analytics_profile IS NOT NULL"]) 

sites.each do |site|

puts "***** #{site.name} ****"

tries = 0

begin
  @profile = Garb::Profile.first(site.analytics_profile)
  
#Garb::Management::Profile.all.detect {|profile| profile.web_property_id == 'UA-XXXXX-X'}

  
rescue => ex
  puts "\t\t\t*** Error loading profile for #{site.name}: #{ex.message}, retrying ..."
  if (tries < 10)
    sleep(1**tries)
    tries +=1
    retry
  end
end

reporting_intervals.each do |i|

  articles = Article.find(:all, :conditions => ['site_id = ? AND pub_date < ? AND legacy_content = ?', site.id, Date.today - i,false])

  articles.each do |a|

    unless view = View.find(:first, :conditions => ['article_id = ? AND article_age = ?',a.id,i])
      begin
        end_date = a.pub_date + i.days
        start_date = end_date - 30.days
        puts "\tUpdating #{i}-day stats for #{a.title}"
        updates +=1
      rescue => ex
        puts "\t\t\t#{ex.class}: #{ex.message}"
      end

      if site.is_cdev == 0 || a.cdev_id == nil
        report_type = "non_cdev"
        report_fragment = a.title.gsub(/(\W)/) { "\\#{$1}" }
      else
        report_type = "cdev"
        report_fragment = a.cdev_id
      end

      begin
        create_view(report_fragment,start_date,end_date,report_type,a.id,i)
      rescue => ex
        puts "\t\t\t#{ex.class}: #{ex.message}"
      end

    end
  end
end
end

puts "#{updates} total records updated."
