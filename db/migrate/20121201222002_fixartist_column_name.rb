class FixartistColumnName < ActiveRecord::Migration
  def change
    rename_column :tracks, :artist, :art
  end
end
