# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#add Saturday Nov 17 song kick venues and artists page 1

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
#for i in 1..artists.length-1 #for page 2 0..6 for saturday
for i in 1..5 #for page 2 0..6 for saturday
  tmpurl = 'http://www.songkick.com'+locations[i]['href']
  tmpdoc = Nokogiri::HTML(open(tmpurl))
  street_address = store_field(tmpdoc, '.street-address')
  postal_code = store_field(tmpdoc, '.postal-code')
  locality = store_field(tmpdoc, '.locality')

  #print output
  puts "#{artists[i].text},#{locations[i].text},#{street_address},#{postal_code},#{locality}"
  #artist = {'name' => artists[i].text}
  #puts artist.to_json
  #venue = {'name' => locations[i].text, 'streetadress' => street_address}
  #puts venue.to_json

  venue = Venue.create! do |v|
    v.name = locations[i].text
    v.streetaddress = street_address
    v.zip = postal_code
    v.city = 
  end

  artist = Artist.create! do |a|
    a.name = artists[i].text
  end
end

