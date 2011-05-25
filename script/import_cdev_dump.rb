#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../config/environment'
require "uri"


import_file = File.read("/Users/mike/Desktop/all_articles_feb11.txt")


discarded_domains = ["boston.internet.com","dc.internet.com","siliconvalley.internet.com","www.atnewyork.com","www.drmwatch.com","www.webvideouniverse.com",]


import_file.each do |row|
  fields = Array(row.split("^"))

  test_domain = URI.parse(fields[2]).host

  next if discarded_domains.include?(test_domain)

  unless test_domain.include?("codeguru")
    if fields.size != 6
      puts "Bad field count: #{fields}"
      next
    end
  end


  article = Article.find_or_create_by_cdev_id(fields[0])
  article.legacy_content = false # use this flag only for backports

  article.container_id = fields[1]
  article.url = fields[2]
  article.title = fields[3]
  article.pub_date = Date.parse(fields[4])


  if fields[5] != nil
    author_name = fields[5].strip.squeeze(" ")
  else
    author_name = "No Author"
  end

  domain = URI.parse(article.url).host

  if domain == "itmanagement.earthweb.com"
    article.site = Site.find(11)
  else
    article.site = Site.find_by_site_domain(domain)
  end

  next if article.site == nil

  if article.site_id == 26
    article.author = Author.find(7)
  else
    article.author = Author.find_or_create_by_name(author_name)
  end

  begin
    if article.site.has_agcon == 1
      if article.url.match(article.site.agcon_white_paper) || article.url.match(article.site.agcon_market_research) || article.url.match(article.site.agcon_news)
        article.content_source = ContentSource.find_by_code("A")
        article.content_type = ContentType.find_by_code("A")
      end
    end
  rescue
    puts "Error with site: #{fields[0]}"
  end

  article.editor = article.site.editor

  begin
    article.save(:validate => false)
    puts "Saved #{article.title} - #{article.site.name}"
  rescue => ex
    puts "Couldn't save #{article.title} - #{article.site.name} -- #{ex.message}"
  end

end

