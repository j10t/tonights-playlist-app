class AddHeadlinerToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :headliner, :boolean
  end
end
