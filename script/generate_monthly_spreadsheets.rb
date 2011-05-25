#!/usr/bin/env ruby -W1

RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../config/environment'
require "spreadsheet"

period_start = "2011-02-01"
period_end = Date.parse(period_start).end_of_month
email_month = Date.parse(period_start).strftime("%B")
short_month = Date.parse(period_start).strftime("%b-%Y")
mail = app("Mail")

sheet_directory = File.dirname(__FILE__) + "/../public/spreadsheets"
model_spreadsheet = File.dirname(__FILE__) + "/models/model_editor_spreadsheets.xls"
non_cms_spreadsheet = File.dirname(__FILE__) + "/models/non-cms-site.xls"

Spreadsheet.client_encoding = 'UTF-8'

editors = Editor.find(:all)#, :conditions => ["name = ?", "Michael Hall"])

editors.each do |e|
  next if e.sites.size < 1 

  puts "#{e.name}"
  site_names = ""
  editor_sheet_name = e.name.downcase.gsub(/\W/, "-")

#  next unless sites = Site.find(:all, :conditions => ["is_cdev = ? AND editor_id =?", true, e.id])

  ss_list = [non_cms_spreadsheet]

  e.sites.each do |s|
    
    next unless s.is_cdev == true || s.is_contentengine == true

    site_names +=  "\t- #{s.name}\n"
    ss_name = s.name.gsub(/\W/,"-").downcase
    ss_output = "#{sheet_directory}/#{editor_sheet_name}-#{ss_name}-#{short_month}.xls"


    book = Spreadsheet.open model_spreadsheet
    sheet = book.worksheet 0

    articles = Article.find(:all, :conditions => ["pub_date >= ? AND pub_date <= ? AND site_id = ? AND content_source_id IS NULL", period_start, period_end, s.id])

    row = 1

    articles.each do |a|
      sheet[row,0] = a.site.name
      sheet[row,1] = a.title
      sheet[row,2] = a.pub_date.strftime("%Y-%m-%d")
      sheet[row,3] = a.author.name
      sheet[row,8] = a.url
      sheet[row,9] = a.id
      row +=1
    end
    
    
    book.write ss_output
    
    ss_list << ss_output
    
  end

end
