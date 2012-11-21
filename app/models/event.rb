class Event < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  attr_accessible :city, :date, :fulladdress, :streetaddress, :venue, :zip, :skbuyurl

  validates :venue, presence: true
  validates :skbuyurl, uniqueness: true
end
