class Track < ActiveRecord::Base
  belongs_to :event, :foreign_key => 'event_id'

  attr_accessible :artist,:album,:name,:source,:sourceid,:event_id

  validates :event_id, presence: true
  validates :artist , presence: true
end
