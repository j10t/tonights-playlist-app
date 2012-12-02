class Artist < ActiveRecord::Base
  has_many :eventartists, foreign_key: "artist_id"
  has_many :events, :through => :eventartists
  has_many :tracks, :dependent => :destroy

  attr_accessible :name

  validates :name, presence: true
  validates :name, uniqueness: true
end
