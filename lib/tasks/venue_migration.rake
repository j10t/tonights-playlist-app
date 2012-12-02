namespace :data do
  desc "Delete venue data from Events and add to Venues"
  task :migratevenues => :environment do
    Event.find(:all, :order => 'id DESC').each do |e|
      #find venue if it exists
      v=Venue.find_by_name(e.venue)
      #if it doesn't create a venue
      if v.nil?
        v = Venue.create do |ven|
          ven.name          = e.venue
          ven.streetaddress = e.streetaddress
          ven.city          = e.city
          ven.zip           = e.zip
          ven.fulladdress   = e.fulladdress
        end
        if v.save
          puts "#{v.name} created"
        else
          puts "Error saving #{e.venue}: #{v.errors.messages.inspect}"
        end
      end
      #save the venue_id for the event, skip validation
      puts "Error saving event:#{e.id}: #{e.errors.messages.inspect}" if !e.update_attribute('venue_id',v.id)
    end
  end
end

