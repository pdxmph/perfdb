#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../config/environment'

report_file = File.new('/Users/mike/rails/perfdb/public/data_sources/full_report.csv', "w")
verticals = Vertical.all

report_file.puts "Vertical|Site|Pub Date|Title|Author|Content Type|Content Source|Cost|Effort|Total Cost|30 Day Views|30 Day Revenue|60 Day Views|60 Day Revenue|90 Day Views|90 Day Revenue|120 Day Views|120 Day Revenue|150 Day Views|150 Day Revenue|180 Day Views|180 Day Revenue|210 Day Views|210 Day Revenue|240 Day Views|240 Day Revenue|270 Day Views|270 Day Revenue|300 Day Views|300 Day Revenue|330 Day Views|330 Day Revenue|360 Day Views|360 Day Revenue|Lifetime Gross Revenue|Lifetime Net Revenue|Lifetime Views|Article Age"

verticals.each do |v|

  v.sites.reportable.each do |s|

    periods = [30,60,90,120,150,180,210,240,270,300,360]

    articles = s.articles.no_agcon.complete.where("pub_date < ?", "2011-01-01")

    articles.each do |a|


      next if a.all_recorded_views == 0
      report_string = ""

      report_string += "#{a.site.vertical.name}|#{a.site.name}|#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.cost}|#{a.effort}|#{a.total_cost}|"


      periods.each do |p|

        if a.has_stats_for(p)


          unless a.view_record_at(p).revenue_knowable? == false
            report_string += a.view_record_at(p).pageviews.to_s + "|" + a.view_record_at(p).revenue.to_s + "|"
          else
            report_string += a.view_record_at(p).pageviews.to_s + "|0|"
          end

        else
          report_string += "0|0|"
        end


      end

      report_string += "#{a.lifetime_gross}|#{a.lifetime_net_revenue}|#{a.all_recorded_views}|#{a.age}"
      report_file.puts report_string

    end
  end
end

report_file.close
