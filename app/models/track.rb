class Track < ActiveRecord::Base
  attr_accessible :album, :name, :source, :sourceid

  validates :name, presence: true
  #TODO add validation for other fields
end
