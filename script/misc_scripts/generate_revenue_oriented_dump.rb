#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'

output_file = File.open(File.dirname(__FILE__) + '/../public/data_sources/revenue_oriented_report.csv', 'w')


output_file.puts "Pub Date|Vertical|Site|Type|Source|Title|Author|Editor|30 Day Views|30 Day Gross Revenue|30 Day Net Revenue"
Article.original.complete.all.each do |a|
  unless a.gross_30_day_revenue == 0
    output_file.puts "#{a.pub_date}|#{a.site.vertical.name}|#{a.site.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.title}|#{a.author.name}|#{a.editor.name}|#{a.views_at(30)}|#{a.gross_30_day_revenue}|#{a.net_30_day_revenue}"
  end
end

output_file.close
