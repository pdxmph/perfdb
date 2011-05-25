class CDEV
  # v0.4 -- 4/2/08
  # Notes: takes over a lot of cleaning stuff from the repurp script
  # 0.2 - Added "pubdate," "pracnetdate" and "pracnetnews" methods for automated PracNet news updating
  # 0.3 - Drops InternetNews lead-in from their titles
  # 0.4 - undoing the 0.3 change, adding some whitespace/extra return cleanup
  # 0.5 - fixed whitespace for sites that have good markup to begin with, more cleanup
  # 0.6 - push a clean version up to the broken children
  # 0.7 - 4/29/09: modified for use with Dreamhost servers, cleaned up the author detection so it doesn't crash when it encounters an authorless story.
  # 0.8 - 8/18/09: added some code to support LinuxPlanet content, added ServerWatch as an attributed site


  require 'rubygems'
  require 'hpricot'
  require "nokogiri"
  require 'open-uri'
  require 'summarize'
  require 'erb'
  require 'sanitize'
  


    def normalize_hpricot(element)
      element.children.each do |child|

        if child.respond_to?(:etag=)
          child.etag = child.etag.downcase if child.etag
        end
        if child.respond_to?(:raw_attributes=)
          attribs = {}

          begin
            child.raw_attributes.each_pair do |key,value|
              attribs[key.downcase] = value if value
            end
            child.raw_attributes = attribs
          rescue
          end
        end
        normalize_hpricot(child) if child.respond_to?(:children) and child.children
      end
      return element
    end


    def initialize(url)

      @url = url;
      #  @hp = normalize_hpricot(open(@url) { |f| Hpricot f, :xhtml_strict => true })

      begin
        @hp = normalize_hpricot(Nokogiri::HTML(open(@url)))
      rescue 
        
        @hp = nil
        
      end
      
      return nil if @hp == nil 
      
      @well = @hp.search("#contentwell") # narrows doc down to innermost div with content
      @bygraf = (@hp/"p:contains('feedback.php')").inner_html
      @hp.search('div[@id*="callout"]').remove
      @hp.search('div[@class*="dimRelatedArticles"]').remove
      @hp.search('div[@class*="toolbox"]').remove

      @text = @hp.to_s

      if @url.include?("internetnews.com")
        @hp.search('//*[@id*="callout"]').remove
        @well = @hp.search("#contentwell") # narrows doc down to innermost div with content
        @bygraf = (@hp/"p:contains('feedback.php')").first
      elsif @url.include?("itmanagement.earthweb.com")
        @bygraf = (@hp/"div.arti_content_photoholder").inner_html
      end

      def plain_text
        return Sanitize.clean(content)
      end
      

      def summarized
        article = Sanitize.clean(content)
        return article.summarize(:ratio => 50)
      end

      def pub_date
        begin
          return Date.parse(@hp.search("//meta[@name='date']").first["content"])
        rescue
          return nil
        end
      end


      def topics
        article = Sanitize.clean(content)
        return article.summarize(:topics => true)[1]
      end


      def deck
        begin
          return @hp.search("//meta[@name='description']").first["content"]
        rescue
          puts "Something went wrong with the deck"
        end
      end


      def author
        begin
          if @url.include?("internetnews.com")
            @author = /feedback\.php.+?>(.+?)<\/a>/.match(@bygraf.inner_html)[1].to_s
          else
            @author = @hp.search("//meta[@name='authors']").first["content"]
          end
        rescue
          puts "Something went wrong with the author"
        end
      end


      begin
        def title
          if @url.include?("internetnews.com")
            @title = (@hp/"title").inner_text.gsub!(/ - InternetNews.com/,"")
          else
            @title=(@hp/"title").inner_text
          end
        end
      rescue
        puts "Something went wrong with the title"
      end


      def content
        begin
          @text.gsub!(/\s(\S+?)\s\((<a.+?\">)define<\/a>\)/,  " \\2\\1</a>")
          @text.gsub!(/\ \((NASDAQ|NYSE):.+?\)/imx,"")
          @text.gsub!(/\w{1,}\.webopedia\.com/, "networking.webopedia.com")
          @text.gsub!(/<QUOTE.+?>&nbsp;/,"")
          @text.gsub!(/&#146;/,"'")
          @text.gsub!(/[\n|\r]{3,}/,"")
          @text.gsub!(/&#150;/,"&ndash;")
          @text.gsub!(/&#151;/,"&mdash;")
          @text.gsub!(/&#9[1|3];/,"\'")
          @text.gsub!(/&quot;/,"\"")
          @text.gsub!(/<p>/,"\n\n<p>")
          @text.gsub!(/\s+?<\/p>/, "<\/p>")
          @text.gsub!(/<\/p>\s{2,}/, "</p>\n\n")

          # define CDEV story delimiters

          unless @url.include?("linuxplanet.com")
            @start_mark = "<!--content_start-->"
            @end_mark = "<!--content_stop-->"
          else
            @start_mark = "<!--.+?begin\ content.+?-->"
            @end_mark = "<!--.+?end\ content.+?-->"
          end
          @content = @text.scan(%r{#{@start_mark}(.*?)#{@end_mark}}m).to_s
          @content = @content.gsub(/<\!--.+?>/,"")

        rescue
          puts "Something went wrong with the content"
        end
      end


      def id
        begin
          @id = /article\.php\/(\d{4,})/.match(@url)[1].to_s
        rescue
          return
        end
      end


      begin
        def domain
          topurl = /(http:\/\/.+?)\//.match(@url)[1].to_s
          @domain = topurl.gsub(/htt.+?\/\//, "")
        end
      rescue
        puts "Something went wrong with the domain"
      end
      begin
        def url
          @url = @url.strip;
        end
      rescue
      end

      def pracnetdate
        Date.today.strftime("%m/%d/%y")
      end

      begin
        def sourcesite
          if url.include?("internetnews.com")
            @sourcesite = "InternetNews.com"
          elsif url.include?("enterpriseitplanet")
            @url = "Enterprise IT Planet"
          elsif url.include?("wi-fiplanet")
            @sourcesite = "Wi-Fi Planet"
          elsif url.include?("voipplanet")
            @sourcesite = "Enterprise VoIP Planet"
          elsif url.include?("itmanagement.earthweb.com")
            @sourcesite = "Datamation"
          elsif url.include?("esecurityplanet.com")
            @sourcesite = "eSecurity Planet"
          elsif url.include?("enterprisenetworkingplanet.com")
            @sourcesite = "Enterprise Networking Planet"
          elsif url.include?("enterprisestorageforum.com")
            @sourcesite = "Enterprise Storage Forum"
          elsif url.include?("linuxplanet.com")
            @sourcesite = "Linux Planet"
          elsif url.include?("serverwatch.com")
            @sourcesite = "ServerWatch"
          elsif url.include?("enterprisemobiletoday.com")
            @sourcesite = "Enterprise Mobile Today"
          else @sourcesite = "### Source Site Here ###"
          end
        end
      rescue
        puts "Something went wrong with the sourcesite"
      end


      def pracnetnews
        @pracnetnews = "<p><a href=\"#{url}\"><b>#{title}</b></a><br>#{deck}  &mdash; #{pracnetdate}</p>"
      end

      def repurp
@template = <<END_OF_TEMPLATE
<!--
Head: <%= @title %>
Author: <%= @author %>
Original URL: <%= @url %>

<% if @deck !=nil %>
Deck: <%= @deck %>
<% end %>
-->


<p>
<em>


WRITE YOUR SUMMARY HERE


</em>
</p>

<hr>



<%= @content %>


<p style="text-align:center;font-size:150%;">Read "<a href="<%= @url %>"><%= @title %></a>" at <%= @sourcesite %></p>
END_OF_TEMPLATE

        @repurperb = ERB.new(@template)
        @repurp = @repurperb.result

      end
    end

  
end
