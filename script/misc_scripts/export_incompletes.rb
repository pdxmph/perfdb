#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../../config/environment'

articles = Article.no_legacy.incomplete

articles.each do |a|
  begin
    puts "#{a.pub_date}|#{a.title}|#{a.site.name}|#{a.cost}|#{a.content_source_id}|#{a.content_type_id}|#{a.effort}|#{a.url}"
  rescue
    puts "Error with article -> #{a.id}"
  end
end
