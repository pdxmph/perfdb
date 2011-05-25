#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'

sheet_name = "2010-12 Revenue.xls"
import_dir = File.dirname(__FILE__) + '/../import_files/revenue_sheets'
import_sheet = "#{import_dir}/#{sheet_name}"

month = 12

revenue_month = "2010-#{month}-01"

book = Spreadsheet.open(import_sheet)

sheet = book.worksheet 0

sheet.each 1 do |row|

  if site = Site.find_by_site_domain(row[0])
    if site_stat = site.site_stats.find_by_month(revenue_month)
      site_stat.revenue = row[1]

      unless site_stat.pageviews == nil
        site_stat.revenue_per_view = site_stat.revenue/site_stat.pageviews
      end
      site_stat.save
    end
  else
    puts "Didn't find domain #{row[0]}."
  end


end
