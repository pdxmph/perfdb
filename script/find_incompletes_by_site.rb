#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'
require File.dirname(__FILE__) + '/../config/environment'


Site.all.each do |s|

  incomplete_months = []

  articles = s.articles.incomplete.where("pub_date > ?", "2010-09-30")

  next if articles.size == 0

  puts "- #{s.name} (#{s.id}): #{articles.size} (#{s.editor.name}/#{s.editor.id})"

  articles.each do |a|
    incomplete_months <<  a.pub_date.beginning_of_month
  end

  incomplete_months.uniq!
  incomplete_months.sort!
  incomplete_months.each do |im|
    puts "\t- #{im}"
  end
puts "\n"

end
