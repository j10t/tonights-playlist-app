namespace :data do
  desc "Add Seattle songkick events"
  task :songkicksea => :environment do

    require 'open-uri'
    require 'nokogiri'
    require 'date'

    baseurl = "http://www.songkick.com"

    #save buyurls for page 1 thru 5
    buyurls = []
    puts "saving buyurls..."
    for i in 1..5
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

    def create_track(event,artist, headliner)
      track = event.tracks.build do |t|
        t.artist = artist
        t.headliner = headliner
      end
      if track.save
        puts "#{event.venue} track saved for artist #{artist}"
      else
        puts "error saving track for #{event.venue} on #{event.date}"
      end
    end

    event_count = 1
    page_count  = 1
    #loop through buyurls
    buyurls.each do |buyurl|
      puts "event:#{event_count} page:#{page_count}"
      event_count+=1
      page_count+=1 if event_count%50==0

      #check if buyurl exists in database
      if !Event.find_by_skbuyurl(baseurl+buyurl['href']).nil?
        puts "Event already in database"
        next
      end
      #skip SAM event
      next if buyurl['href']=="/festivals/524544-elles-at-sam/id/14063229-elles-at-sam-2012"

      #browse to buyurl page
      doc = Nokogiri::HTML(open(baseurl+buyurl['href'], "UserAgent" => "Mozilla/6.0 (Windows NT 6.2; WOW64; rv:16.0.1) Gecko/20121011 Firefox/16.0.1"))

      #parse date
      if doc.css('.vevent h2').empty?
        puts "Error parsing date for #{baseurl+buyurl['href']}" 
        next
      else
        date_ary = doc.css('.vevent h2').text.strip.split(' ')
        month = sprintf('%02d',Date::MONTHNAMES.index(date_ary[2]))
        day = date_ary[1]
        year = date_ary[3]
        date = "#{month}/#{day}/#{year}"
      end

      #parse venue
      venue = store_field(doc,'.org a')

      #parse address
      street_address = store_field(doc, '.street-address')
      postal_code = store_field(doc, '.postal-code')
      locality = store_field(doc, '.locality')
      city = locality.split(',')[0]

      #parse additional details
      additional_details_ary = doc.css('.additional-details')
      if additional_details_ary.empty?
        puts "Empty additional details for #{baseurl+buyurl['href']}" 
        additional_details = ''
      else
        additional_details = additional_details_ary.text.split('Additional details')[1].strip
      end

      event = Event.new do |e|
        e.venue = venue
        e.streetaddress = street_address
        e.zip = postal_code
        e.city = city
        e.fulladdress = street_address+' '+locality+' '+postal_code
        e.date = date
        e.additionaldetails = additional_details
        e.skbuyurl = baseurl+buyurl['href']
      end

      if event.save
        puts "#{event.venue} saved on #{event.date}"
      else
        puts "error saving #{event.venue} on #{event.date}"
      end
      
      #create a track object for headliner
      headliner = store_field(doc, '.headliner a')
      create_track(event, headliner, true)

      #create a track object for other bands in lineup if they exist
      lineup_ary = doc.css('.line-up a')
      next if lineup_ary.empty?
      #skip headliner so start at 1 not 0
      for i in 1..lineup_ary.length-1
        create_track(event,lineup_ary[i].text, false)
      end

      sleep(2)
      
    end #end buyurls loop

  end
end
