#seed 11/18/2012 & 11/19/2012 & some 11/20/2012 data

namespace :data do
  desc "Add songkick data for 11/18/2012 and 11/19/2012"
  task :seed1 => :environment do

    require 'open-uri'
    require 'nokogiri'
    require 'json'

    url = 'http://www.songkick.com/metro_areas/2846-us-seattle'
    doc = Nokogiri::HTML(open(url))

    def store_field(doc, selector)
      if !doc.css(selector).nil?
        text = doc.css(selector).text
      else
        text = ''
      end
      return text
    end

    #saturday artists page one
    artists = doc.css('.artists strong')
    locations = doc.css('.location a')
    for i in 1..artists.length-1 #for page 2 0..6 for saturday
    #for i in 1..5 #for page 2 0..6 for saturday
      tmpurl = 'http://www.songkick.com'+locations[i+1]['href']
      tmpdoc = Nokogiri::HTML(open(tmpurl))
      street_address = store_field(tmpdoc, '.street-address')
      postal_code = store_field(tmpdoc, '.postal-code')
      locality = store_field(tmpdoc, '.locality').split(',')[0]

      #print output
      #puts "#{artists[i].text},#{locations[i].text},#{street_address},#{postal_code},#{locality}"
      #artist = {'name' => artists[i].text}
      #puts artist.to_json
      #venue = {'name' => locations[i].text, 'streetadress' => street_address}
      #puts venue.to_json

      event = Event.create! do |e|
        e.venue = locations[i+1].text
        e.streetaddress = street_address
        e.zip = postal_code
        e.city = locality.split(',')[0]
        e.fulladdress = street_address+' '+locality+' '+postal_code
        case i
        when 1..25
          e.date = "11/18/2012"
        when 26..34
          e.date = "11/19/2012"
        else
          e.date = "11/20/2012"
        end
      end
      track = event.tracks.build do |t|
        t.artist = artists[i].text
      end
      if track.save
        puts "#{event.venue} track saved"
      else
        puts "error saving track"
      end
    end
  end
end
