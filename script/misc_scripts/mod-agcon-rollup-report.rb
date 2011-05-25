#!/usr/bin/env ruby

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../config/qs-garb-setup.rb'


### Spreadsheet Setup

#change to POSIX path where you want the output file to be saved
spreadsheet_output = "/Users/mike/Desktop/agcon_rollup.xls"

# Create a spreadsheet object to work with
book = Spreadsheet::Workbook.new
sheet = book.create_worksheet

range_starts = ["2010-05-01","2010-06-01","2010-07-01","2010-08-01","2010-09-01","2010-10-01","2010-11-01","2010-12-01","2011-01-01","2011-02-01"]

sites = Site.find(:all,:conditions => ["has_agcon = ?",1])


def agcon_report(agcon_path,starting_date,ending_date)

  report = Garb::Report.new(@profile,
  :start_date => starting_date,
  :end_date => ending_date,
  :limit => 1000)

  report.metrics :pageviews, :entrances, :bounces
  report.dimensions :page_path
  report.sort :pageviews.desc
  report.filters :page_path.contains => "#{agcon_path}"
  total_entrances, total_pageviews, total_bounces  = 0,0,0

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

def period_views(starting_date,ending_date)
  report = Garb::Report.new(@profile,
  :start_date => starting_date,
  :end_date => ending_date)
  report.metrics :pageviews, :entrances, :bounces

  pageviews = 0

  bounce_rate = "%.2f" % (report.results[0].bounces.to_f/report.results[0].entrances.to_f) * 100

  return Array[pageviews, bounce_rate]
end


row = 0

sheet[row,0] = "Site"
sheet[row,1] = "Container"
sheet[row,2] = "Reporting Period"
sheet[row,3] = "Container Views"
sheet[row,4] = "Container % Site Total Views"
sheet[row,5] = "Container Bounce Rate"
sheet[row,6] = "Cost Per Pageview"
sheet[row,7] = "'Net' Revenue"

row +=1

sites.each do |s|
  sheet[row,0] = s.name
  row +=1
  @profile = Garb::Profile.first(s.analytics_profile)

  #  containers = [s.agcon_news, s.agcon_white_paper, s.agcon_market_research]
 # containers = {s.agcon_news => 750} #, s.agcon_white_paper => 350, s.agcon_market_research => 350}

  puts s.name

  startcol = 1
  sheet[row,startcol] = s.name

  range_starts.each do |rs|
    puts "\tRunning report for period beginning #{rs}."
    sheet[row,startcol + 1] = rs

    container_report = agcon_report(s.agcon_news,Date.parse(rs), Date.parse(rs).end_of_month)
    site_stats = period_views(Date.parse(rs), Date.parse(rs).end_of_month)

    rpv = s.site_stats.find(:first, :conditions => ["month = ?",Date.parse(rs)]).revenue_per_view


    #sheet[row,startcol + 2] = site_stats[0] ## not using = total site views for period

    sheet[row,startcol + 2] = container_report[0] # show container page views for period
    sheet[row,startcol + 3] = (container_report[0].to_f/site_stats[0].to_f)*100 # show container % of total page views for period
    sheet[row,startcol + 4] = container_report[1] # show container bounce rate
    sheet[row,startcol + 5] = "%5.2f" % (v.to_f/container_report[0].to_f) # show container cost per pageview
    unless rpv == nil || rpv == 0
      sheet[row,startcol + 6] = rpv
    end
    row +=1
  end
end

book.write spreadsheet_output
