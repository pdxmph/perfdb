#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'

output_file = File.open(File.dirname(__FILE__) + '/../public/data_sources/zero_views_report.csv', 'w')

articles = Article.no_legacy

output_file.puts "id|pub_date|title|site|editor|url"
articles.each do |a|
  unless a.all_recorded_views > 0
    begin
      output_file.puts "#{a.id}|#{a.pub_date}|#{a.title}|#{a.site.name}|#{a.site.editor.name}|#{a.url}"
    rescue
      puts "Error with article -> #{a.id}"
    end
  end
end

output_file.close
