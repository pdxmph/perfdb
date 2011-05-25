#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../config/environment'

book = Spreadsheet.open(File.dirname(__FILE__) + '/../import_files/cms_reports/ce_february.xls')

ce_domains = ["www.developer.com", "www.infostor.com"]

sheet = book.worksheet 0

sheet.each 1 do |row|

  #  next if row[1] == nil
  domain = row[0]
  next unless ce_domains.include?(domain)

  # get the values from the sheet
  path = row[1]
  art_title = row[2]

  if row[3] != nil
    author_name = row[3]
  else
    author_name = "No Author"
  end


  pub_date = row[5]

  # find some things or put some new values together
  art_url = "http://" + domain + path

  article_site = Site.find_by_site_domain(domain)
  article_author = Author.find_or_create_by_name(author_name)
  article_editor = article_site.editor


  unless article_site == nil
    #    puts "Found the site #{article_site.name} @ #{domain}"

   if a = Article.find(:first, :conditions => ["title = ? AND url =?",art_title,art_url])
 #   puts a.inspect

      puts "We already have #{art_title} on #{article_site.name}."
    else

      new_article = Article.new do |a|
        a.title = art_title
        a.site = article_site
        a.pub_date = pub_date
        a.author = article_author
        a.url = art_url
        a.editor = article_editor
        a.legacy_content = false
      end

      puts new_article.title
      new_article.save
    end

  end
end
