#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require "spreadsheet"



site_id = 29
period_start = "2010-05-01"
period_end = Date.parse(period_start).end_of_month
email_month = Date.parse(period_start).strftime("%B")
short_month = Date.parse(period_start).strftime("%m%Y")

sheet_directory = File.dirname(__FILE__) + '/../public/reports/spreadsheets'
model_spreadsheet = File.dirname(__FILE__) + '/models/model_editor_spreadsheets.xls'


Spreadsheet.client_encoding = 'UTF-8'


s = Site.find(site_id)
e = s.editor

editor_sheet_name = e.name.downcase.gsub(/\W/, "-")


ss_name = s.site_name.gsub(/\W/,"-").downcase
ss_output = "#{sheet_directory}/#{editor_sheet_name}-#{ss_name}-#{short_month}.xls"


book = Spreadsheet.open model_spreadsheet
sheet = book.worksheet 0

articles = Article.find(:all, :conditions => ["pub_date >= ? AND pub_date <= ? AND site_id = ?", period_start, period_end, s.id])

row = 1

articles.each do |a|
  sheet[row,0] = a.site.site_name
  sheet[row,1] = a.title
  sheet[row,2] = a.pub_date.strftime("%Y-%m-%d")

begin
  sheet[row,3] = a.author.name
rescue
    sheet[row,3] = "No Name Listed"
  end
  
  sheet[row,4] = a.content_type.code
  sheet[row,5] = a.content_source.code
  sheet[row,6] = a.cost
  sheet[row,7] = a.effort
  sheet[row,8] = a.url
  sheet[row,9] = a.id
  row +=1
end


book.write ss_output
