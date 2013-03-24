class Track < ActiveRecord::Base
  belongs_to :artist, :foreign_key => 'artist_id'

  attr_accessible :name,:album,:source,:sourceid,:artist_id

  validates :artist_id, presence: true
  validates :name, presence: true
  validates :source, presence: true
  validates :sourceid, presence: true

  #only one sourceid per artist - could potentially have same vid be for multiple artists tho
  validates_uniqueness_of :sourceid, :scope => :artist_id

end
