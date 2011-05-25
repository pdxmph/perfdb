#!/usr/bin/env ruby

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'

### Spreadsheet Setup

range_starts = ["2010-01-01","2010-02-01","2010-03-01","2010-04-01"]#,"2010-09-01","2010-10-01","2010-11-01","2010-12-01","2011-01-01","2011-02-01"]

sites = Site.find(:all,:conditions => ["has_agcon = ?",1])

def agcon_report(agcon_path,starting_date)
  start = Date.parse(starting_date)
  total_entrances, total_pageviews, total_bounces  = 0,0,0

  report = Garb::Report.new(@profile,
  :start_date => start,
  :end_date => start.end_of_month,
  :limit => 1000)

  report.metrics :pageviews, :entrances, :bounces
  report.dimensions :page_path
  report.sort :pageviews.desc
  report.filters :page_path.contains => "#{agcon_path}"


  report.results.each do |r|
    total_pageviews += r.pageviews.to_i
    total_bounces += r.bounces.to_i
    total_entrances += r.entrances.to_i
  end
  if total_entrances == 0 || total_bounces == 0
    bounce_rate = 0
  else
    bounce_rate = (total_bounces.to_f/total_entrances.to_f).to_f * 100
  end

  return Array[total_pageviews,bounce_rate]
end


sites.each do |s|
  puts s.name
  @profile = Garb::Profile.first(s.analytics_profile)


  range_starts.each do |rs|
    
    puts "\t#{rs}"
    site_stat = s.site_stats.find_by_month(rs)
    
    container_report = agcon_report(s.agcon_news,rs)

    unless site_stat == nil
      site_stat.agcon_pageviews = container_report[0]
      site_stat.agcon_bounce_rate = container_report[1]
      site_stat.save
    end
    


    # 
    # 
    # puts "#{rs}|#{s.vertical.name}|#{s.name}|#{rpv}|#{period_views}|#{container_report[0]}|#{container_report[1]}"
    # #puts "#{rs}|#{s.vertical.name}|#{s.name}|#{site_report}"
    # 
    # 



    #sheet[row,startcol + 2] = site_stats[0] ## not using = total site views for period

    #   sheet[row,startcol + 2] = container_report[0] # show container page views for period
    #   sheet[row,startcol + 3] = (container_report[0].to_f/site_stats[0].to_f)*100 # show container % of total page views for period
    #   sheet[row,startcol + 4] = container_report[1] # show container bounce rate
    #   sheet[row,startcol + 5] = "%5.2f" % (v.to_f/container_report[0].to_f) # show container cost per pageview
    #   unless rpv == nil || rpv == 0
    #     sheet[row,startcol + 6] = rpv
    #   end
    #   row +=1
    # end
  end
end
  #book.write spreadsheet_output
