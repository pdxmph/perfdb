#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'
require "spreadsheet"



editor_name = "Glen Kunene"
period_start = "2010-10-01"
period_end = Date.parse(period_start).end_of_month
email_month = Date.parse(period_start).strftime("%B")
short_month = Date.parse(period_start).strftime("%m%Y")

#sheet_directory = File.dirname(__FILE__) + '/../public/reports/spreadsheets/updates/'
model_spreadsheet = File.dirname(__FILE__) + '/models/model_editor_spreadsheets.xls'
sheet_directory = "/Users/Mike/Desktop/"

Spreadsheet.client_encoding = 'UTF-8'

e = Editor.find_by_name(editor_name)#, :conditions => ["name = ?", "Michael Hall"])


editor_sheet_name = e.name.downcase.gsub(/\W/, "-")

#sites = Site.find(:all, :conditions => ["is_cdev = ? AND editor_id =?", true, e.id])

sites = e.sites

if sites.size == 0 
  break
end

ss_list = []

sites.each do |s|

  ss_name = s.name.gsub(/\W/,"-").downcase
  ss_output = "#{sheet_directory}/#{editor_sheet_name}-#{ss_name}-#{short_month}.xls"


  book = Spreadsheet.open model_spreadsheet
  sheet = book.worksheet 0

  articles = Article.find(:all, :conditions => ["pub_date >= ? AND pub_date <= ? AND site_id = ?", period_start, period_end, s.id])

  row = 1

  articles.each do |a|
    sheet[row,0] = a.site.name
    sheet[row,1] = a.title
    sheet[row,2] = a.pub_date.strftime("%Y-%m-%d")
    sheet[row,3] = a.author.name
    # sheet[row,4] = a.content_type.code
    # sheet[row,5] = a.content_source.code
    # sheet[row,6] = a.cost
    # sheet[row,7] = a.effort
    sheet[row,8] = a.url
    sheet[row,9] = a.id
    row +=1
  end


  book.write ss_output

end

