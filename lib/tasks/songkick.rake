namespace :data do
  desc "Add Seattle songkick events"
  task :songkicksea => :environment do

    require 'open-uri'
    require 'nokogiri'
    require 'date'

    baseurl = "http://www.songkick.com"

    #save buyurls for page 1 thru 20
    buyurls = []
    for i in 1..20
      url = baseurl+"/metro_areas/2846-us-seattle?page=#{i.to_s}"
      url = baseurl+"/metro_areas/2846-us-seattle" if i==1
      doc = Nokogiri::HTML(open(url))
      buyurls += doc.css('.button')
    end

    def store_field(doc, selector)
      if !doc.css(selector).nil?
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

    #loop through buyurls
    buyurls.each do |buyurl|
      #check if buyurl exists in database
      next if !Event.find_by_skbuyurl(buyurl).nil?
      #if not, browse to buyurl page
      doc = Nokogiri::HTML(open(baseurl+buyurl['href']))

      #parse date
      if doc.css('.vevent h2').nil?
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
      postal_code = store_field(tmpdoc, '.postal-code')
      locality = store_field(tmpdoc, '.locality')
      city = locality.split(',')[0]

      #parse additional details
      addtional_details = doc.css('.additional-details')
      puts "Nil additional details for #{baseurl+buyurl['href']}" if additional_details.nil?
      additional_details = additional_details.text.split('Additional details')[1].strip

      event = Event.create! do |e|
        e.venue = venue
        e.streetaddress = street_address
        e.zip = postal_code
        e.city = city
        e.fulladdress = street_address+' '+locality+' '+postal_code
        e.date = date
        e.additional_details = additional_details
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
      
    end #end buyurls loop

  end
end
