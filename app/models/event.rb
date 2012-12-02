class Event < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  belongs_to :venues, :foreign_key => 'venue_id'

  attr_accessible :city, :date, :fulladdress, :streetaddress, :venue, :zip, :skbuyurl, :venue_id

  validates :venue, presence: true
  validates :skbuyurl, uniqueness: true
end
