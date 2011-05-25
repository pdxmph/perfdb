#!/usr/bin/env ruby

# use this to generate completereport

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

freeze_date = "2011-01-01"

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'

output_file = File.open(File.dirname(__FILE__) + '/../public/data_sources/swatch_historic_report.csv', 'w')

site = Site.find(7)

articles = site.articles.complete.where("pub_date < ? AND pub_date > ?",freeze_date,"2010-04-30")

output_file.puts "Date|Title|Author|Type|Source|30 Day Views|30 Day Unique Views|Lifetime views|Lifetime Unique Views"



articles.each do |a|
  begin
    output_file.puts "#{a.pub_date}|#{a.title}|#{a.author.name}|#{a.content_type.name}|#{a.content_source.name}|#{a.views_at(30)}|#{a.unique_views_at(30)}|#{a.all_recorded_views}|#{a.all_recorded_unique_views}"
  rescue => ex
    puts "Error with article -> #{a.id} #{ex.message}"
  end
end



output_file.close
