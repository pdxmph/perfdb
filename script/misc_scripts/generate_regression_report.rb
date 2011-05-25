#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'

report_file = File.new('/Users/mike/rails/perfdb/public/data_sources/regression_report.csv', "w")
verticals = Vertical.all

report_file.puts "Vertical|Site|Pub Date|Title|Author|Editor|Content Type|Content Source|Cost|Effort|30 Day Views|30 Day BounceRate|60 Day Views|60 Day BounceRate|90 Day Views|90 Day BounceRate|Lifetime Views"

verticals.each do |v|

  v.sites.reportable.each do |s|

    periods = [30,60,90]

    articles = s.articles.no_agcon.complete.where("pub_date < ?", "2010-012-01")

    articles.each do |a|


      next if a.all_recorded_views == 0
      report_string = ""

      report_string += "#{a.site.vertical.name}|#{a.site.name}|#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.editor.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.cost}|#{a.effort}"


      periods.each do |p|

        if a.has_stats_for(p)

            report_string += a.view_record_at(p).pageviews.to_s + "|" + a.view_record_at(p).bouncerate.to_s + "|"
        
        end

      end

      report_string += "#{a.all_recorded_views}"
      report_file.puts report_string

    end
  end
end

report_file.close
