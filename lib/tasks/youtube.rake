require 'open-uri'
require 'json'
require 'timeout'

namespace :data do
  desc "Create youtube tracks for artists with no tracks"
  task :addyoutubetracks => :environment do 
    puts "Adding youtube tracks..."
    Timeout.timeout(600) do #timeout after 10 minutes to avoid high heroku bill
 
      artists = Artist.joins("left join tracks on tracks.artist_id = artists.id").where("tracks.artist_id is null").order(:name)

      artists.each do |artist|
        url = 'http://gdata.youtube.com/feeds/api/videos/-/%7Bhttp%3A%2F%2Fgdata.youtube.com%2Fschemas%2F2007%2Fcategories.cat%7DMusic?max-results=1&alt=json&q=%22'+URI::encode(artist.name)+'%22&format=5&safeSearch=none&v=2'
        result = JSON.parse(open(url).read)
        if result['feed']['openSearch$totalResults']['$t']==0 || result['feed']['entry'].nil?
          puts "Error: No search results for #{artist.name}"
        else
          title    = result['feed']['entry'].first['title']['$t']
          url      = result['feed']['entry'].first['link'].first['href'].split('&').first
          sourceid = url.split('=').last

          artist.tracks.build do |t|
            t.name     = title
            t.source   = 'Youtube'
            t.sourceid = sourceid
            if t.save
              puts "New track saved for #{artist.name} with title: #{title} at #{url}"
            else
              puts "Track save error: #{t.errors.messages.inspect}"
            end
          end
        end
      end #end artists loop
    end #end timeout
  end #end task
end #end namespace
