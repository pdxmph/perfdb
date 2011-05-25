#!/usr/bin/env ruby 

# Bring up the script within the rails environment. 
# From: http://wiki.rubyonrails.org/rails/pages/Environments 
RAILS_ENV = 'development' 
require File.dirname(__FILE__) + '/../config/environment' 
require "spreadsheet"
require "uri"




# get us into the correct directory for the reporting month
base_dir = File.dirname(__FILE__) + "/../import_files/spreadsheets/"
spreadsheets = Dir.glob(base_dir + "*.xls")


=begin column values
a:0 - Site 
b:1 - Title
c:2 - Pub Date
c:3 - Author
d:4 - Content Type
e:5 - Content Source
f:6 - Freelance Cost
g:7 - Effort
h:8 - URL
i:9 - ID
=end

# determine site by determining domain in URL field

spreadsheets.each do |s|
  puts "****** #{s}"
  book = Spreadsheet.open(s)
  sheet = book.worksheet 0

  sheet.each 1 do |row|
    next if row[1] == nil
    
    art_url = row[8]
    

    begin
      art_domain = URI.parse(art_url.strip).host
      article_site = Site.find_by_site_domain(art_domain)
    rescue
      puts "URL error ..."
      puts "#{art_url} -> #{art_domain}"
    end

    begin
      if row[9] != nil
        article = Article.find(row[9])
      else
        article = Article.find_or_create_by_title(row[1])
        article.author = Author.find_or_create_by_name(row[3])
        article.url = row[8]
        article.pub_date =  row[2]
        article.site = article_site
      end
      
     # next if article.content_source == ContentSource.find_by_code("A")
      
      article.content_type = ContentType.find_by_code(row[4].upcase)
      article.content_source = ContentSource.find_by_code(row[5].upcase)
     
      
      article.cost = row[6].to_f
      article.effort = row[7].to_f
      article.editor = article_site.editor

      editor_rate = article.site.editor.hourly_cost.to_f

      article.total_cost = article.cost + article.effort * editor_rate


     # puts article.inspect
      article.save(:validate => false)

    rescue => ex
      puts "\t\tError: article #{row[1]} (#{art_domain})"
      puts "\t\t\t#{s}"
      puts "\t\t\t#{ex.class}: #{ex.message}"
    end


  end
end

