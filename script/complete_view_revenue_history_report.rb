#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'

report_file = File.new('/Users/mike/rails/perfdb/public/data_sources/full_report.csv', "w")
verticals = Vertical.all

report_file.puts "Vertical|Site|Pub Date|Title|Author|Content Type|Content Source|Cost|Effort|Total Cost|30 Day Views|30 Day Revenue|60 Day Views|60 Day Revenue|90 Day Views|90 Day Revenue|120 Day Views|120 Day Revenue|150 Day Views|150 Day Revenue|180 Day Views|180 Day Revenue|210 Day Views|210 Day Revenue|240 Day Views|240 Day Revenue|270 Day Views|270 Day Revenue|300 Day Views|300 Day Revenue|330 Day Views|330 Day Revenue|360 Day Views|360 Day Revenue|Gross Revenue|Net Revenue"

verticals.each do |v|

  v.sites.reportable.each do |s|

    articles = s.articles.no_agcon.complete.where("pub_date < ?", "2011-02-01")

    articles.each do |a|

      next if a.all_recorded_views == 0

      report_file.puts  "#{a.site.vertical.name}|#{a.site.name}|#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.cost}|#{a.effort}|#{a.cost + a.effort*40}|#{a.views_at(30)}|#{a.gross_revenue_at(30)}|#{a.views_at(60)}|#{a.gross_revenue_at(60)}|#{a.views_at(90)}|#{a.gross_revenue_at(90)}|#{a.views_at(120)}|#{a.gross_revenue_at(120)}|#{a.views_at(150)}|#{a.gross_revenue_at(150)}|#{a.views_at(180)}|#{a.gross_revenue_at(180)}|#{a.views_at(210)}|#{a.gross_revenue_at(210)}|#{a.views_at(240)}|#{a.gross_revenue_at(240)}|#{a.views_at(270)}|#{a.gross_revenue_at(270)}|#{a.views_at(300)}|#{a.gross_revenue_at(300)}|#{a.views_at(330)}|#{a.gross_revenue_at(330)}|#{a.views_at(360)}|#{a.gross_revenue_at(360)}|#{a.all_recorded_revenue}|#{a.cost + a.effort*40 - a.all_recorded_revenue}"


    end
  end
end

report_file.close