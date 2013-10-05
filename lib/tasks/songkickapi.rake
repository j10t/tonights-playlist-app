require 'timeout'
require "#{Rails.root}/app/helpers/songkick_helper"

require 'date'

include SongkickHelper

namespace :apidata do
  desc "Add Seattle songkick events"
  task :songkicksea, [:start_page, :stop_page] => :environment do |t, args|
    Timeout.timeout(900) do #timeout after 15 minutes to avoid high heroku bill
      args.with_defaults(:start_page => 1, :stop_page => 5)

      for i in args.start_page..args.stop_page

        SongkickHelper::events_as_json(i).each_with_index do |event, j|

          if !Event.find_by_skbuyurl(event['uri']).nil?
            puts "page #{i} event #{j} already in database"
            next
          end

          if event['type'] != 'Concert'
            puts "page #{i} event #{j} not a concert"
            next
          end

          status = []

          date = event['start']['date']
          time = event['start']['time']
          datetime_raw = event['start']['datetime']
          datetime = datetime_raw.nil? ? date : datetime_raw
          venue_name = event['venue']['displayName']
          artistname = event['performance'][0]['artist']['displayName']
          displaycity = event['location']['city']
          latitude = event['location']['lat']
          longitude = event['location']['lng']        
          skurl = event['uri']

          # find or create venue.
          v = Venue.find_by_name(venue_name)
          if v.nil?
            v = Venue.new do |venue|
              venue.name = venue_name
              venue.city = displaycity
              status << SongkickHelper::save(venue)
            end # venue.new
          else
            status << "Venue exists"
          end

          # find or create event.
          e = v.events.where(:datetime => Time.zone.parse(datetime.to_s)).first 
          if e.nil?
            e = v.events.build do |event|
              event.datetime = datetime
              event.skbuyurl = skurl
              event.lat = latitude
              event.lng = longitude
              status << SongkickHelper::save(event)
            end
          else
            status << "Event exists"
          end

          # find or create artist.
          a = Artist.find_by_name(artistname)
          if a.nil?
            a = Artist.new do |artist|
              artist.name = artistname
              status << SongkickHelper::save(artist)
            end
          else
            status << "Artist exists"
          end

          if (!e.nil? && !a.nil?)
            ea = Eventartist.where(:event_id => e.id, :artist_id => a.id)
            if ea.empty?
              e.eventartists.build do |ea|
                ea.artist_id = a.id
                ea.event_id = e.id
                status << SongkickHelper::save(ea)
              end
            end
          end

          puts "page #{i}, event #{j}: #{status.join(' | ')}"

        end # events_as_json.each

      end # for i in args.start_page..args.stop_page
    end # timeout
  end # task
end # namespace
