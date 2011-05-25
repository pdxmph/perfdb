#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments
RAILS_ENV = 'development'


#require '/Users/mike/rails/perfdb/config/environment'
require File.dirname(__FILE__) + '/../config/environment'

View.all.each do |v|
  begin
    if v.revenue_knowable? == true
      v.revenue = v.revenue_generated.to_f
      v.save
    end
  rescue => ex
    puts "\t\t#{ex.message} (#{ex.class})"
  end
end
