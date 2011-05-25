#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'

report_file = File.new('/Users/mike/rails/perfdb/public/data_sources/full_report.csv', "w")
verticals = Vertical.all

report_file.puts "Vertical|Site|Pub Date|Title|Author|Content Type|Content Source|Cost|Effort|Total Cost|30 Day Views|30 Day Revenue|60 Day Views|60 Day Revenue|90 Day Views|90 Day Revenue|120 Day Views|120 Day Revenue|150 Day Views|150 Day Revenue|180 Day Views|180 Day Revenue|210 Day Views|210 Day Revenue|240 Day Views|240 Day Revenue|270 Day Views|270 Day Revenue|Lifetime Gross Revenue|Lifetime Net Revenue"

verticals.each do |v|

  v.sites.reportable.each do |s|

    periods = [30,60,90,120,150,180,210,240,270,300,330,360]

    articles = s.articles.no_agcon.complete.where("pub_date < ?", "2011-01-01")

    articles.each do |a|

      next if a.all_recorded_views == 0

      begin
        report_file.puts  "#{a.site.vertical.name}|#{a.site.name}|#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.cost}|#{a.effort}|#{a.total_cost}|#{a.view_record_at(30).pageviews}|#{a.view_record_at(30).revenue}|#{a.view_record_at(60).pageviews}|#{a.view_record_at(60).revenue}|#{a.view_record_at(90).pageviews}|#{a.view_record_at(90).revenue}|#{a.view_record_at(120).pageviews}|#{a.view_record_at(120).revenue}|#{a.view_record_at(150).pageviews}|#{a.view_record_at(150).revenue}|#{a.view_record_at(180).pageviews}|#{a.view_record_at(180).revenue}|#{a.view_record_at(210).pageviews}|#{a.view_record_at(210).revenue}|#{a.view_record_at(240).pageviews}|#{a.view_record_at(240).revenue}|#{a.view_record_at(270).pageviews}|#{a.view_record_at(270).revenue}|#{a.lifetime_gross}|#{a.lifetime_net_revenue}"

      rescue => ex
        puts "#{ex.message} -- #{ex.class} -- #{a.id}"
      end

    end
  end
end

report_file.close
