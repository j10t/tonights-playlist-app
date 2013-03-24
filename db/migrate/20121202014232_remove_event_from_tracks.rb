class RemoveEventFromTracks < ActiveRecord::Migration
  def up
    remove_column :tracks, :art
    remove_column :tracks, :event_id
    remove_column :tracks, :headliner
  end

  def down
    add_column :tracks, :event_id, :integer
    add_column :tracks, :art, :string
    add_column :tracks, :headliner, :boolean
  end
end
