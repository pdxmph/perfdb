#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'

report_file = File.new('/Users/mike/rails/perfdb/public/data_sources/full_report-no-revenue.csv', "w")
verticals = Vertical.all

report_file.puts "Vertical|Site|Pub Date|Title|Author|Content Type|Content Source|Cost|Effort|Total Cost|30 Day Views|60 Day Views|90 Day Views|120 Day Views|150 Day Views|180 Day Views|210 Day Views|240 Day Views|270 Day Views|Lifetime Views|Article Age"

verticals.each do |v|

  v.sites.reportable.each do |s|

    periods = [30,60,90,120,150,180,210,240,270]

    articles = s.articles.no_agcon.complete.where("pub_date < ?", "2011-02-01")

    articles.each do |a|

      next if a.all_recorded_views == 0
      report_string = ""

      report_string += "#{a.site.vertical.name}|#{a.site.name}|#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.cost}|#{a.effort}|#{a.total_cost}|"


      periods.each do |p|
        if a.has_stats_for(p)
          report_string += a.view_record_at(p).pageviews.to_s + "|"
        else
          report_string += "0|"
        end
      end
      report_string += "#{a.all_recorded_views}|#{a.age}"
      report_file.puts report_string
    end


  end
end

report_file.close
