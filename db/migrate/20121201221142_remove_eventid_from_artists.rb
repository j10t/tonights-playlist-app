class RemoveEventidFromArtists < ActiveRecord::Migration
  def up
    remove_column :artists, :event_id
  end

  def down
    add_column :artists, :event_id, :integer
  end
end
