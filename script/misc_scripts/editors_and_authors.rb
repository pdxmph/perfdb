#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'

require '/Users/mike/rails/perfdb/config/environment'
#require File.dirname(__FILE__) + '/../config/environment'

editor_list = File.open("/Users/mike/desktop/editor_list.csv","w")
Editor.all.each do |e|

  author_list = []

  articles = e.articles.original.find(:all, :conditions => ["pub_date > ?", "2009-01-01"])

  articles.each do |a|
    author_list << "#{a.site.editor.name}|#{a.site.name}|#{a.author.name}"
  end

  author_list.uniq!
  editor_list.puts author_list
end

editor_list.close
