#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'
require "rubygems"
require "page_rankr"


#seo_metrics_file = File.open("/Users/mike/Desktop/seo_metrics.csv", "w")
#seo_metrics_file.puts "Site|PageRank|Google Backlinks|Reported Domain"

gather_date = Date.today

Site.all.each do |site|

  unless SeoStat.find(:first, :conditions => ["gather_date = ? AND site_id = ?",gather_date,site.id])
    puts "*** Processing #{site.name}"

    begin
      puts "\tGathering ranks ..."
      ranks = PageRankr.ranks(site.site_domain, :google)
      pr = ranks[:google]
      sleep 120

      puts "\tGathering backlinks ..."
      backlinks = PageRankr.backlinks(site.site_domain, :google, :bing, :yahoo, :alexa)
      sleep 120
      
      puts "\tGathering indexed pages ..."
      indexed_pages = PageRankr.indexes(site.site_domain, :google, :bing)
      sleep 120


    rescue => ex
      puts ex.message
      next
    end

    seo_stat = SeoStat.new(:site => site, :gather_date => gather_date)


    seo_stat.google_pagerank = pr
    seo_stat.google_backlinks = backlinks[:google]
    seo_stat.yahoo_backlinks = backlinks[:yahoo]
    seo_stat.bing_backlinks = backlinks[:bing]
    seo_stat.alexa_backlinks = backlinks[:alexa]
    seo_stat.google_indexed_pages = indexed_pages[:google]
    seo_stat.bing_indexed_pages = indexed_pages[:bing]

    seo_stat.save

    
  end




end
