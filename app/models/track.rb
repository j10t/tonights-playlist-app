class Track < ActiveRecord::Base
  belongs_to :artist, :foreign_key => 'artist_id'

  attr_accessible :name,:album,:source,:sourceid,:artist_id

  validates :artist_id, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :sourceid, uniqueness: true

end
