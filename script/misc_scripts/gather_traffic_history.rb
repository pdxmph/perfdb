#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'
#require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'
require '/Users/mike/rails/perfdb/config/qs-garb-setup.rb'


def search_traffic_report(site,report_date,search_engine,country)

  begin
    report = Garb::Report.new(@profile,
    :start_date => report_date,
    :end_date => report_date)

    report.metrics :visits
    report.dimensions :medium, :source

    if country == "us"
      report.filters :medium.contains => "organic", :source.contains => search_engine, :country.contains => "United States"
    else
      report.filters :medium.contains => "organic", :source.contains => search_engine, :country.does_not_contain => "United States"
    end

    total_visits = 0.0

    report.results.each do |r|
      total_visits += r.visits.to_i
    end

    return total_visits

  rescue => ex
    puts "#{ex.message}/#{ex.class}"
  end
end

def non_search_traffic_report(site,report_date,traffic_medium)

  begin
    report = Garb::Report.new(@profile,
    :start_date => report_date,
    :end_date => report_date)

    report.metrics :visits
    report.dimensions :medium

    report.filters :medium.contains => traffic_medium

    total_visits = 0.0

    report.results.each do |r|
      total_visits += r.visits.to_i
    end

    return total_visits

  rescue => ex
    puts "#{ex.message}/#{ex.class}"
  end
end

def visits_and_views_report(site,report_date)

  begin
    report = Garb::Report.new(@profile,
    :start_date => report_date,
    :end_date => report_date)

    report.metrics :visits, :pageviews
    #    report.dimensions :medium

    #    report.filters :medium.contains => traffic_medium

    total_visits = 0.0
    total_pageviews = 0.0
    report.results.each do |r|
      total_visits += r.visits.to_i
      total_pageviews += r.pageviews.to_i
    end

    return {:total_visits => total_visits, :total_pageviews => total_pageviews}
   # return [total_visits,total_pageviews]

  rescue => ex
    puts "#{ex.message}/#{ex.class}"
  end
end






#sites = Site.find(:all, :conditions => ["name =?","Webopedia"])

channels = Channel.find(2,1,3,4,5)

channels.each do |c|

#  sites = c.sites.find(:all, :conditions => ["analytics_profile IS NOT NULL"])
#sites = channels.sites.find(:all, :conditions => ["analytics_profile IS NOT NULL"])

#sites = Site.reportable


#sites = Site.find(:all, :conditions => ["analytics_profile IS NOT NULL"])
sites = c.sites#, :conditions => ["priority_report IS TRUE"])

sites.each do |site|

  starting_date = Date.parse("2011-03-08")

  puts "Loading profile for #{site.name} ..."

  tries = 0

   begin
     tries +=1
  @profile = Garb::Profile.first(site.analytics_profile)

  rescue Timeout::Error => ex
          puts ex.message
          if (tries < 10)
            sleep(5**tries)
            retry
          end
        end


  puts "\tGathering stats ..."

  while starting_date > Date.parse("2011-01-26")


    unless SearchStat.where("record_date = ? AND site_id =?",starting_date,site.id).exists?
      #puts starting_date


      search_stat = SearchStat.new(:site_id => site.id)
      search_stat.google_us_visits = search_traffic_report(site,starting_date,"google","us")
      search_stat.google_non_us_visits = search_traffic_report(site,starting_date,"google","nonus")
      search_stat.bing_us_visits = search_traffic_report(site,starting_date,"bing","us")
      search_stat.bing_non_us_visits = search_traffic_report(site,starting_date,"bing","nonus")
      search_stat.yahoo_us_visits = search_traffic_report(site,starting_date,"yahoo","us")
      search_stat.yahoo_non_us_visits = search_traffic_report(site,starting_date,"yahoo","nonus")
      search_stat.direct_visits = non_search_traffic_report(site,starting_date,"none")
      search_stat.referred_visits = non_search_traffic_report(site,starting_date,"referral")
      
      views_report = visits_and_views_report(site,starting_date)
      
      search_stat.total_pageviews = views_report[:total_pageviews]
      search_stat.total_visits = views_report[:total_visits]
      
      search_stat.record_date = starting_date
      search_stat.save


    end
    starting_date -= 1.day

  end
end
end
