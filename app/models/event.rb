class Event < ActiveRecord::Base
  belongs_to :venue, :foreign_key => 'venue_id'
  has_many :eventartists, foreign_key: "event_id", :dependent => :destroy
  has_many :artists, :through => :eventartists

  attr_accessible :date, :skbuyurl, :venue_id

  validates :venue_id, presence: true
  validates :date, presence: true
  #TODO add uniqueness index validation in model for [venue_id,date]
  validates :skbuyurl, uniqueness: true, :allow_nil => true
end
