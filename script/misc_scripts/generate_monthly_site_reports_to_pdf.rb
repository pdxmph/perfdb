#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'


base = "http://localhost:3000"
output_dir  = File.dirname(__FILE__) + '/../public/reports/'

year = "2010"

months = [12]

months.each do |month|
#  sites = Site.all

  #sites = GeneralManager.find(1).sites

  Site.reportable.each do |cs|

    # filename = "#{cs.short_name}-cumulative.pdf"
    filename = "#{cs.short_name}-#{year}-#{month}.pdf"
    date = "#{year}/#{month}"
    id = cs.id


    `~/bin/wkhtmltopdf #{base}/sites/#{id}/reports/overview/#{date} #{base}/sites/#{id}/reports/content/#{date} #{output_dir}/#{filename} `

    #  `~/bin/wkhtmltopdf #{base}/sites/#{id}/ #{base}/sites/#{id}/reports/content/ #{output_dir}/#{filename} `


  end
end
