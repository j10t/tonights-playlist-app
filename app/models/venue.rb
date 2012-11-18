class Venue < ActiveRecord::Base
  attr_accessible :city, :fulladdress, :name, :streetaddress, :zip

  validates :name, presence: true
  #TODO add validation for other fields
end
