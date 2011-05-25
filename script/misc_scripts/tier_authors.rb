#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment' 
#require File.dirname(__FILE__) + '/../config/environment'

book = Spreadsheet.open("/Users/mike/Desktop/new_tiers.xls")

sheet = book.worksheet 0

sheet.each 1 do |row|
  if author = Author.find_by_name(row[0])
    puts "Found #{author.name} (#{author.tier} -> #{row[1]})"
    author.tier = row[1]
    author.save
  end
end