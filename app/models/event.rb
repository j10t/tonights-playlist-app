class Event < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  belongs_to :venue, :foreign_key => 'venue_id'

  attr_accessible :date, :skbuyurl, :venue_id

  validates :venue_id, presence: true
  validates :skbuyurl, uniqueness: true
end
