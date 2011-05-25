#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment' 
#require File.dirname(__FILE__) + '/../config/environment'

#authors = Author.find(:all)

articles = Article.find(:all, :conditions => ["pub_date > ? AND legacy_content IS NULL", "2010-04-30"])

articles.each do |a|
    a.legacy_content = false
    a.save
    puts "#{a.title} - #{a.pub_date}"
end