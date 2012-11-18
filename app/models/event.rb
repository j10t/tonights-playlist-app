class Event < ActiveRecord::Base
  has_many :tracks, :dependent => :destroy
  attr_accessible :city, :date, :fulladdress, :streetaddress, :venue, :zip

  validates :venue, presence: true
end
