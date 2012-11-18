class Eventartist < ActiveRecord::Base
  attr_accessible :artist_id, :event_id

  validates :artist_id, presence: true
  validates :event_id, presence: true
end
