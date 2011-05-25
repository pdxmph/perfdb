#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../lib/CDEV'

# class ="paging", child: span class="numbers"

# http://www.enterprisenetworkingplanet.com/netos/article.php/3487081/Join-Samba-3-to-Your--Active-Directory-Domain.htm


articles = Site.find(22).articles

articles.each do |a|
  begin
  art = CDEV.new(a.url)
  puts "#{a.title}\t#{a.cdev_id}\t#{a.pub_date}\t#{a.views_30_day}\t#{art.is_paginated?}\t#{art.paragraph_count}"
rescue
end
end
