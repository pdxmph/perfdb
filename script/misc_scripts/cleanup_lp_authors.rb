#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../../config/environment'
require "CDEV"


s = Site.find(5)

articles = s.articles.find(:all, :conditions => ["pub_date IN (?)", "2010-05-01".."2010-05-31"])

articles.each do |a|
  puts "For #{a.title}:"
  puts "\tAuthor: #{a.author.name}"
  cdev = CDEV.new(a.url)
  puts "\tCDEV Author found: #{cdev.author}"

end

