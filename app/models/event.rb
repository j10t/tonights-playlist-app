class Event < ActiveRecord::Base
  attr_accessible :date, :time

  validates :date, presence: true
end
