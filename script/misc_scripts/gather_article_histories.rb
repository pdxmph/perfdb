#!/usr/bin/env ruby

# Bring up the script within the rails environment.
# From: http://wiki.rubyonrails.org/rails/pages/Environments

RAILS_ENV = 'development'

require File.dirname(__FILE__) + '/../../config/environment'
require File.dirname(__FILE__) + '/../../config/qs-garb-setup.rb'

def site_article_report(site,start_date)

  begin
    report = Garb::Report.new(@profile,
    :start_date => start_date,
    :end_date => start_date + 6.days,
    :sort => :pageviews.desc,
    :limit => 500,
    :offset => 500)

    report.metrics :pageviews
    report.dimensions :page_path, :page_title

    return report

  rescue => ex
    puts "#{ex.message}/#{ex.class}"
  end
end



#voip planet is 8

begin
  sites = Site.find(5,22)#:all, :conditions => ["name = ?","ServerWatch"])
  # sites = Site.find(:all, :conditions => ["name = ?","ServerWatch"])
  sites.each do |site|


    start_date = Date.parse("2011-02-27")
    stop_date = start_date + 6.days

    puts "Loading profile for #{site.name} ..."
    tries = 0

    begin
      tries +=1
      @profile = Garb::Profile.first(site.analytics_profile)

    rescue Timeout::Error => ex
      puts ex.message
      if (tries < 10)
        sleep(5**tries)
        retry
      end
    end


    puts "\tGathering stats ..."

    while start_date > Date.parse("2010-09-04")

      found,unfound = 0,0

      #while start_date > Date.parse("2011-02-21")
      puts "#{start_date}"
      report = site_article_report(site,start_date)

      report.results.each do |r|

        unless ReportArticle.where("title = ?", r.page_title).exists?

          unfound += 1
          if r.page_path =~ /enterprisestorageforum/
            url = "http://#{r.page_path}"
          else
            url = "http://#{site.site_domain}#{r.page_path}"
          end

         
          cdev = CDEV.new(url)
          if r.page_path =~ /article\.php/
            begin
              date = cdev.pub_date
              topics = cdev.topics
              
              
            rescue => ex
              puts "#{ex.message}"
              date = ""
              topics = ""
            end
          else
            date = ""
            topics = ""
          end

      #**    puts "\t- #{r.page_title} : #{topics}"
          report_article = ReportArticle.new(:title => r.page_title, :path => url, :pub_date => date, :site_id => site.id)
          report_article.save
        else
          report_article = ReportArticle.find(:first, :conditions => ["title =?", r.page_title])
          found +=1
        end
        
        
        unless ReportStat.where("report_article_id = ? AND report_date = ?", report_article.id, start_date).exists?
          report_stat = ReportStat.new(:report_article_id => report_article.id, :report_date => start_date)
        else
          report_stat = ReportStat.find(:first, :conditions => ["report_article_id = ? AND report_date = ?", report_article.id, start_date])
        end

        if report_stat.pageviews == nil
          report_stat.pageviews = r.pageviews.to_i
        else
          report_stat.pageviews += r.pageviews.to_i
        end
        report_stat.save




      end
      puts "Found: #{found}, Unfound: #{unfound}"
      start_date -= 1.week

    end
  end
end
