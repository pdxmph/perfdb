#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'

articles = Article.no_legacy

articles.each do |a|
  begin
    a.total_cost = a.effort * a.editor.hourly_cost + a.cost
    puts "#{a.title}: #{a.total_cost} (#{a.effort}/#{a.editor.hourly_cost}/#{a.cost})"
    a.save
  rescue => ex
    puts "#{ex.message} (#{ex.class})"
  end
end
