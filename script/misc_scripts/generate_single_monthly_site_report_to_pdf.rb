#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'


base = "http://localhost:3000"
output_dir  = File.dirname(__FILE__) + '/../public/reports/'
year = "2010"
months = [9]

cs = Site.find(29)

months.each do |m|  
  filename = "#{cs.short_name}-#{year}-#{m}.pdf"
  date = "#{year}/#{m}"
  id = cs.id

    
  `~/bin/wkhtmltopdf #{base}/sites/#{id}/reports/overview/#{date} #{base}/sites/#{id}/reports/content/#{date} #{output_dir}/#{filename} `
end