module SongkickHelper
  require 'httparty'
  require 'json'

  def events_uri(page)
    return "https://api.songkick.com/api/3.0/metro_areas/2846/calendar.json?apikey=#{ENV['SONGKICK_API_KEY']}&page=#{page}"
  end

  def events_as_string(page)
    return HTTParty.get(self.events_uri(page)).body
  end
  
  def events_as_json(page)
    return JSON.parse(self.events_as_string(page))["resultsPage"]["results"]["event"]
  end

  def save(obj)
    obj.save ? "New #{obj.class.to_s} saved" : "#{obj.class.to_s} save error: #{obj.errors.messages.inspect}"
  end

end
