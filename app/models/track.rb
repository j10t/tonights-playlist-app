class Track < ActiveRecord::Base
  belongs_to :event, :foreign_key => 'event_id'

  attr_accessible :album, :artist, :event_id, :name, :source, :sourceid

  validates :event_id, presence: true
  validates :name, presence: true
end
