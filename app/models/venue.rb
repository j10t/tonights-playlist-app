class Venue < ActiveRecord::Base
  has_many :events, :dependent => :destroy

  attr_accessible :city, :fulladdress, :name, :streetaddress, :url, :zip

  validates :name, presence: true
  validates :name, uniqueness: true
  validates_format_of :zip, :with => /^\d{5}(-\d{4})?$/, :message => "should be in the form 12345 or 12345-1234", :allow_nil => true
  #TODO add url validation

end
