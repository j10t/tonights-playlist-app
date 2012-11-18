class Artist < ActiveRecord::Base
  #TODO only admins only accessible
  attr_accessible :name

  validates :name, presence: true
end
