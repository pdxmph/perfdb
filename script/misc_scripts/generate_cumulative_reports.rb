#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'


base = "http://localhost:3000"
output_dir  = File.dirname(__FILE__) + '/../public/reports/'
sites = GeneralManager.find(1).sites

sites.each do |cs|

  filename = "#{cs.short_name}-cumulative.pdf"

  id = cs.id


  `~/bin/wkhtmltopdf #{base}/sites/#{id}/ #{base}/sites/#{id}/reports/content/ #{output_dir}/#{filename} `


end
