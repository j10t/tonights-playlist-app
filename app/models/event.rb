class Event < ActiveRecord::Base
  belongs_to :venue, :foreign_key => 'venue_id'
  has_many :eventartists, foreign_key: "event_id", :dependent => :destroy
  has_many :artists, :through => :eventartists

  attr_accessible :datetime, :skbuyurl, :additionaldetails,:venue_id

  validates :venue_id, presence: true
  validates :datetime, presence: true
  #only one event per venue per day
  validates_uniqueness_of :datetime, :scope => :venue_id
  validates :skbuyurl, uniqueness: true, :allow_nil => true
end
