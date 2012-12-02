class Event < ActiveRecord::Base
  belongs_to :venue, :foreign_key => 'venue_id'
  has_many :eventartists, foreign_key: "event_id", :dependent => :destroy
  has_many :artists, :through => :eventartists

  attr_accessible :date, :skbuyurl, :additionaldetails,:venue_id

  validates :venue_id, presence: true
  validates :date, presence: true
  #only event per venue per day
  validates_uniqueness_of :date, :scope => :venue_id
  validates :skbuyurl, uniqueness: true, :allow_nil => true
end
