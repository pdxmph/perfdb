#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../../config/environment'

authors = Author.find(:all, :conditions => ["is_staff IS FALSE"])

authors.each do |a|
  articles = a.articles.no_legacy.original

  articles.each do |art|
    unless art.total_cost == 0 || art.all_recorded_views == 0 || art.content_source.code == "I" || art.content_source.code == "R"
      begin
        puts "#{art.author.name}|#{art.site.name}|#{art.site.vertical.name}|#{art.pub_date}|#{art.cost}|#{art.effort}|#{art.effort * 40}|#{art.cost + art.effort * 40}|#{art.views_at(30)}|#{art.views_at(60)}|#{art.views_at(90)}|#{art.views_at(120)}|#{art.views_at(150)}|#{art.views_at(180)}|#{art.views_at(210)}|#{art.views_at(240)}|#{art.all_recorded_views}|#{art.content_type.name}|#{art.author.tier}"
      rescue
      end
    end
  end
end
