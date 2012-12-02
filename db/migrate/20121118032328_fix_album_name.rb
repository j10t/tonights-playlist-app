class FixAlbumName < ActiveRecord::Migration
  def up
    rename_column :tracks, :albume, :album
  end

  def down
  end
end
