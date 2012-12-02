class Venue < ActiveRecord::Base
  has_many :events, :dependent => :destroy

  attr_accessible :city, :fulladdress, :name, :streetaddress, :url, :zip

  validates :name, presence: true
  validates :name, uniqueness: true

end
