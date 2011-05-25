#!/usr/bin/env ruby -W0

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'


Site.all.each do |site|
  stats = site.site_stats.find(:all, :conditions => ["month = ?","2010-12-01"])
  
  stats.each do |s|
    if s.revenue == nil 
      puts "#{site.name}: #{s.month}"
    end
  end
end