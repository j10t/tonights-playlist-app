class Venue < ActiveRecord::Base
  attr_accessible :city, :fulladdress, :name, :streetaddress, :url, :zip

  validates :name, presence: true

end
