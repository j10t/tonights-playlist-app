require 'timeout'

namespace :data do
  desc "Add Seattle songkick events"
  task :songkicksea, [:start_page, :stop_page] => :environment do |t, args|
    Timeout.timeout(900) do #timeout after 15 minutes to avoid high heroku bill
      args.with_defaults(:start_page => 1, :stop_page => 5)

      require 'open-uri'
      require 'nokogiri'
      require 'date'

      baseurl = "https://www.songkick.com"

      buyurls = []
      puts "saving buyurls..."
      #save buyurls for pages args.start_page thru args.stop_page
      for i in args.start_page..args.stop_page
        puts "saving page #{i}"
        url = baseurl+"/metro_areas/2846-us-seattle?page=#{i.to_s}"
        url = baseurl+"/metro_areas/2846-us-seattle" if i==1
        doc = Nokogiri::HTML(open(url, "UserAgent" => "Mozilla/6.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"))
        buyurls += doc.css('.button')
        sleep(2)
      end

      def store_field(doc, selector)
        if !doc.css(selector).empty?
          text = doc.css(selector).text
        else
          text = ''
        end
        return text
      end

      event_count = 1
      page_count  = 1
      #loop through buyurls
      buyurls.each do |buyurl|
        puts "event:#{event_count} page:#{page_count}"
        event_count+=1
        page_count+=1 if event_count%50==1

        #check if buyurl exists in database
        if !Event.find_by_skbuyurl(baseurl+buyurl['href']).nil?
          puts "Event already in database"
          next
        end

        #browse to buyurl page
        doc = Nokogiri::HTML(open(baseurl+buyurl['href'], "UserAgent" => "Mozilla/6.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"))

        #parse date
        if doc.css('time[itemprop]').empty?
          puts "Error parsing date for #{baseurl+buyurl['href']}" 
          next
        else
          date_str    = doc.css('time[itemprop]').first.attributes['datetime'].value  # format "2013-09-14"
          date_array  = date_str.split('-')
          year     = date_array[0].to_i
          month    = date_array[1].to_i
          day      = date_array[2].to_i
          datetime = DateTime.new(year,month,day)
        end

        #parse venue
        loc = doc.css('.location')
        if loc.nil?
          puts "Error parsing venue location for #{baseurl+buyurl['href']}"
        else
          venue_name = loc.css('a').first.text unless loc.css('a').first.nil?

          #parse address
          adr = loc.css('.adr')
          if !adr.nil?
            puts "Error parsing venue address for #{baseurl+buyurl['href']}"
          else
            street_address = adr.css('.street-address').text unless adr.css('.street-address').nil?
            postal_code = adr.css('.postal-code').text unless adr.css('.postal-code').nil?
            locality = adr.css('.locality').text unless adr.css('.locality').nil?
            city = locality.split(',').first
          end
        end

        #parse additional details
        additional_details_ary = doc.css('.additional-details')
        if additional_details_ary.empty?
          additional_details = ''
        else
          additional_details = additional_details_ary.text.split('Additional details')[1].strip
        end

        ########### Start storing in database ###########
        #check for venue
        v=Venue.find_by_name(venue_name)
        #create venue if one doesn't exist
        if v.nil?
          v=Venue.new do |ven|
            ven.name          = venue_name
            ven.streetaddress = street_address
            ven.city          = city
            ven.zip           = postal_code
            ven.zip           = nil if postal_code.nil? || postal_code.empty?
            ven.fulladdress   = [street_address, locality, postal_code].join(' ')
            if ven.save
              puts "New venue: #{ven.name} saved"
            else
              puts "Venue save error: #{ven.errors.messages.inspect}"
            end
          end
        end

        #skip SAM event
        if v.name == "Seattle Art Museum"
          puts "skipping SAM event"
          next
        end

        e=nil
        #check for event
        #convert datetime to timewithzone class for where
        e=v.events.where(:datetime => Time.zone.parse(datetime.to_s)).first if !v.events.empty?
        if e.nil?
          #create an event
          e=v.events.build do |event|
            event.datetime          = datetime
            event.additionaldetails = additional_details
            event.skbuyurl          = baseurl+buyurl['href']
            if event.save
              puts "New event saved on #{event.datetime}"
            else
              puts "Event save error: #{event.errors.messages.inspect}"
            end
          end
        end


        def find_or_create_artist(artist)
          #check for artist
          a=Artist.find_by_name(artist)
          #create artist if one doesn't exist
          if a.nil?
            a=Artist.new do |art|
              art.name = artist
              if art.save
                puts "New artist: #{art.name} saved"
              else
                puts "Artist save error: #{art.errors.messages.inspect}"
              end
            end
          end
          return a
        end


        def create_eventartist(event,artist,boolheadliner)
          #return if not unique
          return if !Eventartist.where(:event_id => event.id, :artist_id => artist.id).empty?
          #otherwise create an eventartists relationship
          event.eventartists.build do |ea|
            ea.artist_id = artist.id
            ea.event_id  = event.id
            ea.headliner = boolheadliner
            if ea.save
              puts "New eventartist saved"
            else
              puts "Eventartist save error: #{ea.errors.messages.inspect}"
            end
          end
        end

        #find or create artist headliner
        headliner_name = store_field(doc, '.headliner a')
        a=find_or_create_artist(headliner_name)
        ea = create_eventartist(e,a,true)

        #find or create artist for other bands in lineup if they exist
        lineup_ary = doc.css('.line-up a')
        next if lineup_ary.empty?
        #skip headliner so start at 1 not 0
        for i in 1..lineup_ary.length-1
          a=find_or_create_artist(lineup_ary[i].text)
          ea = create_eventartist(e,a,false)
        end

        sleep(1)
        
      end #end buyurls loop

    end
  end
end
